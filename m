Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab0KZQW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 11:22:28 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51380 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab0KZQW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 11:22:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KW1pFNoI6TgF+yxIs822haycNYID+KRrLub6W5BvHzkqYvXXFxu76nOBcz3jRzKrsx
         AWSb3mFCKquxOpUojdSaoAntddC8hNSoH6M6ODZZMWpZrnBJnRCc6oJO0ypSBHOjyQQ7
         i3qKO10eQ02TSj6mMgcnn2PB0rMKRpzZYkjgI=
Subject: Re: [PATCH 1/1] mtd: nand: add check for out of page read
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jason Liu <r64343@freescale.com>
Cc: David.Woodhouse@intel.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1290156045-11719-1-git-send-email-r64343@freescale.com>
References: <1290156045-11719-1-git-send-email-r64343@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 18:21:53 +0200
Message-ID: <1290788513.2552.33.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 16:40 +0800, Jason Liu wrote:
> When run mtd_oobtest case, there will be one error for step(4),
> which turned out it need add one check for out of page read in
> nand_do_read_oob just like mtd_do_write_oob did it already.
> This commit also fix one typo error for comments in mtd_do_write_oob
> 
> Signed-off-by: Jason Liu <r64343@freescale.com>
> ---
>  drivers/mtd/nand/nand_base.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)

Pushed to l2-mtd-2.6.git, thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

