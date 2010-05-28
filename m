Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab0E1Att (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 20:49:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755088Ab0E1Atq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 20:49:46 -0400
Date: Thu, 27 May 2010 17:46:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Robert Hancock <hancockrwd@gmail.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Bastien Nocera <hadess@hadess.net>
Subject: Re: [git pull] Input updates for 2.6.34-rc6
In-Reply-To: <AANLkTimkI2rLOO2vaPFBQUbzr5t0pAQGQ5R5noTOBp4K@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1005271744410.11382@i5.linux-foundation.org>
References: <20100513075728.GF30110@core.coreip.homeip.net> <alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org> <20100513160117.GB22238@core.coreip.homeip.net> <alpine.LFD.2.00.1005130943460.3711@i5.linux-foundation.org> <4BFE0FAB.9040009@gmail.com>
 <alpine.LFD.2.00.1005270956380.3689@i5.linux-foundation.org> <AANLkTimkI2rLOO2vaPFBQUbzr5t0pAQGQ5R5noTOBp4K@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 27 May 2010, Robert Hancock wrote:
> 
> It's highly unlikely that they are incomplete in this respect, as
> since I mentioned, Windows would fail to recognize the PS/2 controller
> that people would expect to work, which would most likely get
> noticed..

Did you miss the part where I actually quoted my own modern Core i5 
machine that _does_ have a keyboard controller, and _does_ have a keyboard 
port, and that does _not_ mention them in the PnP tables?

> I think this is a case where it has to be trusted, because that's what
> Windows does.

The thing is, Windows isn't used for things like headless machines. Which 
we went over extensively in the thread. There's a _reason_ why Linux 
probes the dang thing.

			Linus
