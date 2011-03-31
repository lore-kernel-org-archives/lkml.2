Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933565Ab1CaGcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 02:32:14 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57298 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab1CaGcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 02:32:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SepJVnrlWgXIbsfJ8Jv5VhzbJNjw2E4mOuVLP8O1OXjUC26AKzKN/1/9xP1d6CMq45
         4cX8F86DVEXnv/cflrWcXVbFQKbsZqLtyayUeHgzbj5GeMyko4YNZkRMwt4R2LGytrrE
         MQ1gxnR48olqyrffkvyXl0y8EE5wGetZvLSM8=
Subject: Re: [PATCH 1/2] UBIFS: do not select KALLSYMS_ALL
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: MTD list <linux-mtd@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20110330154130.e62e04e0.randy.dunlap@oracle.com>
References: <1301474416-8202-1-git-send-email-dedekind1@gmail.com>
	 <1301474416-8202-2-git-send-email-dedekind1@gmail.com>
	 <20110330154130.e62e04e0.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 31 Mar 2011 09:29:53 +0300
Message-ID: <1301552993.2828.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-30 at 15:41 -0700, Randy Dunlap wrote:
> > diff --git a/fs/ubifs/Kconfig b/fs/ubifs/Kconfig
> > index d744090..f8b0160 100644
> > --- a/fs/ubifs/Kconfig
> > +++ b/fs/ubifs/Kconfig
> > @@ -47,7 +47,7 @@ config UBIFS_FS_DEBUG
> >  	bool "Enable debugging support"
> >  	depends on UBIFS_FS
> >  	select DEBUG_FS
> > -	select KALLSYMS_ALL
> > +	select KALLSYMS
> >  	help
> >  	  This option enables UBIFS debugging support. It makes sure various
> >  	  assertions, self-checks, debugging messages and test modes are compiled
> > -- 
> 
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Pushed to UBI / UBIFS trees. These will show-up in linux-next a bit
later (around -rc2, if it will be usable enough), and then I'll send
this to Linus.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

