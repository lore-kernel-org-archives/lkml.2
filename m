Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab0IHU1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 16:27:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34862 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141Ab0IHU1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 16:27:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Fan runs full speed after S3 sometimes (regression)
Date: Wed, 8 Sep 2010 22:26:24 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, linux-acpi@vger.kernel.org,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <4C613619.30309@gmail.com> <20100821170551.GA27159@elf.ucw.cz> <4C878F24.9010004@gmail.com>
In-Reply-To: <4C878F24.9010004@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009082226.24953.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 08, 2010, Jiri Slaby wrote:
> Hi.
> 
> On 08/21/2010 07:05 PM, Pavel Machek wrote:
> >>>>> I don't know how to debug that. Bisection is out of question -- it
> >>>>> happens once in 10 or 20 cases. There are no fan entries in /sys.
> >>>
> >>> Well, doing 20 suspends in a row from a script should not be too bad.
> >>
> >> 20 is just a guess. I haven't seen it for pretty few days until the day
> >> before yesterday. And it looks like CPU1 is brought up a half way. When
> >> the fan was at full speed I tried:
> >> echo 0 > /sys/devices/system/cpu/cpu1/online
> >> and whole system freezed. Otherwise this commands succeeds.
> > 
> > Ok, so this looks like the kernel problem, on the other hand. Two
> > different problems?
> 
> Actually, I haven't seen it after an upgrade to the next -mm kernel.
> Consider it as closed as WORKSFORME for now.

Great, thanks fot the update.  Let's hope it was a temporary glitch.

Thanks,
Rafael
