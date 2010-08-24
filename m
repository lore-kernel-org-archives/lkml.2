Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab0HXKnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 06:43:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33797 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab0HXKne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 06:43:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fferDmEmtQPvgTmPQeAbyHCPHgTiZIuMcLDj0mxhEPWiezvsCgKpcoqE2PdHuQtORq
         yk3OV4kUh5hI3DCDiSP7/17YrxE3RATUvbyMwCsbHiurtq4nXgYK9wGsk5zZDFsb/PFf
         AUmO9AO/dr9tqRsCZf97XKm7OuhgXYSDxW7qU=
Subject: Re: [PATCH v2 0/2] Deprecate ECCGETLAYOUT
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Brian Norris <norris@broadcom.com>
Cc: linux-mtd@lists.infradead.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Sneha Narnakaje <nsnehaprabha@ti.com>
In-Reply-To: <1282154806-9420-1-git-send-email-norris@broadcom.com>
References: <4C5CA4A1.1040000@broadcom.com>
	 <1282154806-9420-1-git-send-email-norris@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 13:42:04 +0300
Message-ID: <1282646524.24044.161.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 11:06 -0700, Brian Norris wrote:
> The following two patches are implementations of two different
> strategies to deprecate the ioctl ECCGETLAYOUT. This ioctl is not
> very useful and imposes restrictions on expanding the corresponding
> kernel struct nand_ecclayout. Either patch will leave functionality
> intact but allow the kernel-space layouts to expand in the future.
> 
> Strategy 1: Create new struct nand_ecclayout_l and convert all kernel
>   code to use this struct.
> Strategy 2: Rename old struct nand_ecclayout_user and modify
>   nand_ecclayout to be used in the kernel only.

I think nand_ecclayout_l is silly name. Strategy 2 looks nicer, let's
stick to that one.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

