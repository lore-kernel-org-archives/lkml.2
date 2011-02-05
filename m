Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab1BEUcc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 15:32:32 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57248 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab1BEUcb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 15:32:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eYs4xkBxO6BvbonQ2WwrjRGfyk4diQ/NEc8bHm+yyfiM+Ad5hbBTe29UEMqpm4f/zy
         E6C13ZnjtGDUmorawyEi6v0Jtz4+zHzpHo0zoZtrmUg1qwTlpoHuH+9rbMXr7twjbril
         VM4/yuyMdG49ehNGCwK1qtQU0/3pLKa2PIBiQ=
MIME-Version: 1.0
In-Reply-To: <20110204.145508.59670453.davem@davemloft.net>
References: <AANLkTimBFBKJf0-TNRLr2hHNEehR2cnKPvx06=yyHGVj@mail.gmail.com>
	<1296852667.2349.804.camel@pasglop>
	<20110204.145508.59670453.davem@davemloft.net>
Date: Sat, 5 Feb 2011 20:32:28 +0000
Message-ID: <AANLkTi=s7Yro4TqtmgW4HPnJx3HiWvX9iJ9NUOYXcR+j@mail.gmail.com>
Subject: Re: Sun GEM PPC32 Bug?
From: Matt <jackdachef@gmail.com>
To: ruediger.herbst@googlemail.com
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        geert@linux-m68k.org, benh@kernel.crashing.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Is there a special Kernel parameter (sysctl.conf), that makes it
>possible to use the Network. So how it is now I canŽt work with it. What
>can I do at the moment?

please add others in the CC

(take a look in the CC field of this mail and you'll know how to do it:
put the person you're answering in the "to" ("an") field :) )

thanks !

there was a kind of temporary solution provided in :
http://ubuntuforums.org/showpost.php?p=9002232&postcount=3

>linuxopjemac, thank you for referring to Ben. He replied and might look into it.

>Meanwhile, I put the module reloading and interface restarting into a cron job that executes every hour: sudo crontab -e

# m h  dom mon dow   command
0  *  *   *   *     /usr/sbin/fix-sungem

>and the script /usr/sbin/fix-sungem contains

/sbin/ifdown eth0 && /sbin/rmmod sungem && /sbin/modprobe sungem &&
/sbin/ifup eth0

Hope that helps somewhat

Regards

Matt
