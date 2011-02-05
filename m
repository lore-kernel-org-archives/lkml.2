Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab1BEXVJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 18:21:09 -0500
Received: from gate.crashing.org ([63.228.1.57]:40311 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853Ab1BEXVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 18:21:08 -0500
Subject: Re: Sun GEM PPC32 Bug?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Matt <jackdachef@gmail.com>
Cc: ruediger.herbst@googlemail.com, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, geert@linux-m68k.org
In-Reply-To: <AANLkTi=s7Yro4TqtmgW4HPnJx3HiWvX9iJ9NUOYXcR+j@mail.gmail.com>
References: <AANLkTimBFBKJf0-TNRLr2hHNEehR2cnKPvx06=yyHGVj@mail.gmail.com>
	 <1296852667.2349.804.camel@pasglop>
	 <20110204.145508.59670453.davem@davemloft.net>
	 <AANLkTi=s7Yro4TqtmgW4HPnJx3HiWvX9iJ9NUOYXcR+j@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Feb 2011 10:20:54 +1100
Message-ID: <1296948054.2349.807.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-02-05 at 20:32 +0000, Matt wrote:
> >Is there a special Kernel parameter (sysctl.conf), that makes it
> >possible to use the Network. So how it is now I canŽt work with it. What
> >can I do at the moment?
> 
> please add others in the CC
> 
> (take a look in the CC field of this mail and you'll know how to do it:
> put the person you're answering in the "to" ("an") field :) )

Note that it's quite hard for me to figure out all the details of that
problem since it seems to be scattered accross various email threads
referring to vastly different kernel versions etc...

Can you guys open a bug at kernel.org's bugzilla, CC me, and put
relevant informations (dmesg logs, description of the problem, etc...)
with a -current- upstream kernel please ?

Cheers,
Ben. 

> thanks !
> 
> there was a kind of temporary solution provided in :
> http://ubuntuforums.org/showpost.php?p=9002232&postcount=3
> 
> >linuxopjemac, thank you for referring to Ben. He replied and might look into it.
> 
> >Meanwhile, I put the module reloading and interface restarting into a cron job that executes every hour: sudo crontab -e
> 
> # m h  dom mon dow   command
> 0  *  *   *   *     /usr/sbin/fix-sungem
> 
> >and the script /usr/sbin/fix-sungem contains
> 
> /sbin/ifdown eth0 && /sbin/rmmod sungem && /sbin/modprobe sungem &&
> /sbin/ifup eth0
> 
> Hope that helps somewhat
> 
> Regards
> 
> Matt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


