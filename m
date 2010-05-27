Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab0E0P2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:28:54 -0400
Received: from enyo.dsw2k3.info ([195.71.86.239]:60742 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757933Ab0E0P2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:28:51 -0400
X-Greylist: delayed 549 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 May 2010 11:28:51 EDT
Date: Thu, 27 May 2010 17:19:24 +0200
From: Matthias Schniedermeyer <ms@citd.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: config automatically switches from 32-bit to 64-bit for x86
Message-ID: <20100527151924.GA1063@citd.de>
References: <AANLkTik0PUKP3QLPRbb3nlh034_inmaeVbXy3q5_LQz-@mail.gmail.com> <201005270213.42913.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005270213.42913.rjw@sisk.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.05.2010 02:13, Rafael J. Wysocki wrote:
> On Thursday 27 May 2010, Jaswinder Singh Rajput wrote:
> > Hello,
> > 
> > I am trying to build 32 bit kernel image on 64-bit machine but after
> > 'make menuconfig' it automatically switches 32-bit to 64-bit.
> 
> Try 'linux32 make menuconfig' and 'linux32 make'.

I personally use the third ARCH (i386 and x86_64 beeing the first two):
make ARCH=x86
that way the bitness isn't implied but an actual configuration-point.
CONFIG_64BIT (The very first menu-point with menuconfig)

And i'm still wondering what the hell the problem is with ARCH=x86 that 
prevents it from beeing the default.



Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

