Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772Ab0EMOro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 10:47:44 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:42747 "EHLO
	relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763Ab0EMOrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 10:47:42 -0400
X-Originating-IP: 217.70.178.41
X-Originating-IP: 82.8.179.104
Subject: Re: [git pull] Input updates for 2.6.34-rc6
From: Bastien Nocera <hadess@hadess.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org>
References: <20100513075728.GF30110@core.coreip.homeip.net>
	 <alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 13 May 2010 15:47:31 +0100
Message-ID: <1273762051.2308.4671.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.0.1 (2.30.0-3.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 07:35 -0700, Linus Torvalds wrote:
> 
> On Thu, 13 May 2010, Dmitry Torokhov wrote:
> > 
> > Bastien Nocera (1):
> >       Input: i8042 - do not try to probe ports on Intel Apple Macs
> 
> I pulled, but I skipped the last commit, because I think this one is 
> fundamentally _wrong_.
> 
> It is _not_ maintainable to create random tables of exceptions ("DMI 
> tables"), and it's actively _wrong_ to do for something like this where we 
> not only have historically worked perfectly well, and this apparently 
> tries to hide some other bug (the commit says "could potentially lock 
> up/hang/wait for timeout for long periods of time").
<snip>
> So if somebody saw "could potentially lock up/hang/wait" issues, then 
> dangit, say what those issues are, AND LET'S FIX THEM! And not like this, 
> trying to hide them for some particular machines, rather than fixing the 
> actual underlying detection bug.

I'm waiting for your debug instructions on that one, because we already
looked at that with Dmitry.

I already got that patch in my distribution, and now my machine boots up
uninterrupted. The lock is somewhat random, and will go away as soon as
I press the power button on my machine.

Maybe you didn't update to the latest firmwares on you Mac Mini, and
didn't see the problem with the updated BIOSes, I don't know.

