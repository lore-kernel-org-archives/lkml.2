Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab0KZQTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 11:19:14 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62234 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab0KZQTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 11:19:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Mpp/zbTt92oj+WA+HPa0mSche9cHb1uyfZaFuF5W07svZiTQvmLLzpLRorqxbqBaYt
         4S08lR7srfz3FanGR9+kFH4rIJ3IQzanBOUYEJY25dFgQ209YGso7Vf8HuU8P/pCWpwE
         XjhakIsTMZ4HIK85dJ18XgcOQvqIAZnWynfm4=
Subject: Re: [PATCH] mtd: fix nand kernel-doc warnings
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org
In-Reply-To: <20101118150221.2f38e9b0.randy.dunlap@oracle.com>
References: <20101118150221.2f38e9b0.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 18:18:39 +0200
Message-ID: <1290788319.2552.32.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 15:02 -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Warning(include/linux/mtd/nand.h:543): No description found for parameter 'badblockbits'
> Warning(drivers/mtd/nand/nand_bbt.c:1101): No description found for parameter 'mtd'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc:	David Woodhouse <dwmw2@infradead.org>
> Cc:	linux-mtd@lists.infradead.org
> ---
>  drivers/mtd/nand/nand_bbt.c |    3 ++-
>  include/linux/mtd/nand.h    |    2 ++
>  2 files changed, 4 insertions(+), 1 deletion(-)

Pushed to l2-mtd-2.6.git, thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

