Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab1GXRXp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 13:23:45 -0400
Received: from lunge.queued.net ([173.255.254.236]:34369 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab1GXRXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 13:23:40 -0400
Date: Sun, 24 Jul 2011 10:23:37 -0700
From: Andres Salomon <dilinger@queued.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Daniel Drake <dsd@laptop.org>, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, x86@kernel.org
Subject: Re: OLPC power management patches - merge for 3.1?
Message-ID: <20110724102337.6efffea7@queued.net>
In-Reply-To: <20110724101323.d5c9bc5a.rdunlap@xenotime.net>
References: <CAGq3pz4VHgagUQ+jGJdt9LL4UnFt+CDgcLLXbuVeKfWMc=0wAA@mail.gmail.com>
	<20110723202032.67ebdbcc.rdunlap@xenotime.net>
	<CAGq3pz6L5VzYaGBN8Py3x9s-orAp9AoG1OMM=1p8KJ1b3TVR6Q@mail.gmail.com>
	<20110724101323.d5c9bc5a.rdunlap@xenotime.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jul 2011 10:13:23 -0700
Randy Dunlap <rdunlap@xenotime.net> wrote:
[...]
> > or
> > 
> > depends on POWER_SUPPLY
> > select POWER_SUPPLY
> > 
> > ?
> 
> You can't do both of those AFAIK -- and it already depends on
> POWER_SUPPLY. I guess you could remove "depends on POWER_SUPPLY" and
> add "select POWER_SUPPLY". I'll see if that works.
> 


Yeah, select appears to be the only option so long as bool stuff in
arch/ depends upon tristate stuff in drivers/.  It'd be nice to get the
OLPC PM code to be modular, but getting it upstream (the code is from
2007 or 2008!) is a nice first step.
