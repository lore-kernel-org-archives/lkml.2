Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab0IQHRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 03:17:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58532 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab0IQHRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 03:17:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 04/12] BKL: Remove BKL from autofs4
Date: Fri, 17 Sep 2010 09:17:29 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-next-20100910+; KDE/4.5.1; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        autofs@linux.kernel.org, Greg KH <greg@kroah.com>
References: <1284659185-8942-1-git-send-email-arnd@arndb.de> <201009161955.48854.arnd@arndb.de> <1284687191.3083.8.camel@localhost>
In-Reply-To: <1284687191.3083.8.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009170917.29522.arnd@arndb.de>
X-Provags-ID: V02:K0:dz+pk0bAa3XOV951+uNBnvkMNatOOhhgm4XmRaXjxZy
 tYgmgtyJtZoE2nyzOAISZP2Q4/GPBg6OD4QGVNAxkYYSmV0FFv
 1f7LdKiEpMpHCaGGEG0Jbz8ggxzP88zVDw9jiZjjqP3wayCTpJ
 LjdrJQ8RgcYZnD0tzfh//Tl06PJc426cfKzPmWtUz4LUsmRjGy
 WkyzRmua0d2sh+nU6GT8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 September 2010 03:33:11 Ian Kent wrote:
> On Thu, 2010-09-16 at 19:55 +0200, Arnd Bergmann wrote:
> > Ah, sorry about this. I looked at the wrong MAINTAINERS entry.
> > 
> > I also forgot to Cc you about autofs3, adding more to the confusion. ;)
> > 
> > Do you think the time has come to move autofs3 to drivers/staging
> > as we deprecate the BKL?
> 
> Umm ... what's this process, the drivers/staging?

We use drivers/staging now both for getting code into the kernel
and for getting it out of there. Moving autofs3 to drivers/staging/autofs/
would serve as a last warning to everyone using it, but users could
still use it while it's there. If anyone is interested, they can submit
fixes (BKL removal and whatever else is needed) to get it back into
the mainline. If it doesn't happen, Greg would finally remove it two
kernel releases later.

My hope is that we can move all modules that still use the BKL after
2.6.37 to drivers/staging, unless we have someone already working
on the patches.

	Arnd
