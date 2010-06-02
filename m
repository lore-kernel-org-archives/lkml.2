Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864Ab0FBWaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 18:30:30 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61335 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757962Ab0FBWa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 18:30:29 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6001"; a="43133539"
Subject: Re: [GIT PULL] ARM MSM updates for 2.6.35-rc1
From: Daniel Walker <dwalker@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1006021413100.8175@i5.linux-foundation.org>
References: <1274997173.10998.21.camel@c-dwalke-linux.qualcomm.com>
	 <1275511857.27006.6.camel@c-dwalke-linux.qualcomm.com>
	 <alpine.LFD.2.00.1006021413100.8175@i5.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Jun 2010 15:30:26 -0700
Message-ID: <1275517826.27006.114.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-02 at 14:27 -0700, Linus Torvalds wrote:
> 
> On Wed, 2 Jun 2010, Daniel Walker wrote:
> > 
> > Don't forget about this one! Or was something wrong with it?
> 
> I got a bit frustrated with ten different ARM pulls per day at one point.
> 
> There's something wrong with ARM development. The amount of pure noise in 
> the patches is incredibly annoying. Right now, ARM is already (despite me 
> not reacting to some of the flood) 55% of all arch/ changes since 2.6.34, 
> and it's all pointless churn in 
> 
> 	arch/arm/configs/
> 	arch/arm/mach-xyz
> 	arch/arm/plat-blah
> 
> and at a certain point in the merge window I simply could not find it in 
> me to care about it any more.
> 
> Do you guys at all talk about this problem? Have any of the ARM people 
> bothered to look at the arch/arm diffs and see how mind-deadening they 
> are? I try to look through these kinds of things when I pull, but after a 
> million lines of pure noise, it gets old pretty quickly.

There's room for the sub-architectures to combine stuff. I think there
is work going on to do that (at some level).

> Somehow, I can't believe that you need thousands of lines for each random 
> arch/arm/mach-xyz (yeah, some very few of them are smaller).

I'm not an authority by any means, but every time there is a new device
released (which is often) you get a new file under some mach-xyz
directory, or some large modification to an already existing file. Plus
a config file potentially. It's a little bit like the wild west, and
seems way wilder than x86 every was.

I think from the sub-architecture maintainer perspective the pain is all
hidden behind the Linus curtain , or RMK curtain or the some other
maintainer curtain. So we don't really talk about it that often. I
thought you we're totally happy with the situation ..

If you have some idea's for fixing things, I'm all ears along with my
faithful sub-architecture maintainer brothers.

Daniel

