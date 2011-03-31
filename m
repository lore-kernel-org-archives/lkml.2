Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964846Ab1CaMJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 08:09:27 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41823 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab1CaMJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 08:09:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=K7VXTHHT5eeM7lsyFfgjWWemW0t12Ir/kO8jFt5ziIzHY5tltlGz4pnLuv7+tBFhcx
         0yA7m4TTfhALuqHwB1w0Lxhh72e8o6KcJxVsZxs+b1VD2BzzEhVTkcdF4EilE+ZYJo+I
         YUnfl32XYM2Rg1MV67JoXXGYQlbVXGY8C4IMk=
Subject: Re: [PATCH] mtd: nand: Fixed null pointer dereference.
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Maarten ter Huurne <maarten@treewalker.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1300286875-21426-1-git-send-email-maarten@treewalker.org>
References: <1300286875-21426-1-git-send-email-maarten@treewalker.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 31 Mar 2011 15:07:04 +0300
Message-ID: <1301573224.2828.50.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-16 at 15:47 +0100, Maarten ter Huurne wrote:
> The "bd" argument of verify_bbt_descr() was dereferenced before it was checked for NULL.
> 
> Signed-off-by: Maarten ter Huurne <maarten@treewalker.org>

Hi, this was fixed in upstream already by another person.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

