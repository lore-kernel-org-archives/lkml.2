Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab1BYMoa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 07:44:30 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:58623 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab1BYMo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 07:44:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lYPLD3kPLXIFPGQ2aqlC0uMumpbGShIq/OCjx6cQqYrYPsHPKxNwfs9vRVYG/BRbLr
         DALE8j+pACWNpE7CHsHM3vkqJ0mc1RtchS0Ahl9CEwWOoQDrU/+e9REsGAnRdmtYmBkv
         btu/i5CPAoz2IKpJPRbXP+FEgFoOGzBEBxHKk=
Subject: Re: [PATCH] mtd: nand: fix one typo in the comments
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jason Liu <r64343@freescale.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, David.Woodhouse@intel.com
In-Reply-To: <1298610378-3105-1-git-send-email-r64343@freescale.com>
References: <1298610378-3105-1-git-send-email-r64343@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 14:43:05 +0200
Message-ID: <1298637785.2798.106.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-25 at 13:06 +0800, Jason Liu wrote:
> In the function nand_do_write_oob, the comments
> has one typo, this patch fix it.
> 
> - /* Do not allow reads past end of device */
> + /* Do not allow write past end of device */
> if (unlikely(to >= mtd->size ||
> 	     ops->ooboffs + ops->ooblen >
> 		((mtd->size >> chip->page_shift) -
> 		 (to >> chip->page_shift)) * len)) {
> 	DEBUG(MTD_DEBUG_LEVEL0, "%s: Attempt write beyond "
> 			"end of device\n", __func__);
> 	return -EINVAL;
> }
> 
> Signed-off-by: Jason Liu <r64343@freescale.com>

Oh, please, do not copy the patch into the commit message! It is enough
to say that you fix a typo in a commentary.

But I've amended the commit message and pushed the patch to my
l2-mtd-2.6.git tree, thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

