Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766Ab0FBVbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 17:31:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54021 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758048Ab0FBVbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 17:31:46 -0400
Date: Wed, 2 Jun 2010 14:27:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Daniel Walker <dwalker@codeaurora.org>
cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [GIT PULL] ARM MSM updates for 2.6.35-rc1
In-Reply-To: <1275511857.27006.6.camel@c-dwalke-linux.qualcomm.com>
Message-ID: <alpine.LFD.2.00.1006021413100.8175@i5.linux-foundation.org>
References: <1274997173.10998.21.camel@c-dwalke-linux.qualcomm.com> <1275511857.27006.6.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Jun 2010, Daniel Walker wrote:
> 
> Don't forget about this one! Or was something wrong with it?

I got a bit frustrated with ten different ARM pulls per day at one point.

There's something wrong with ARM development. The amount of pure noise in 
the patches is incredibly annoying. Right now, ARM is already (despite me 
not reacting to some of the flood) 55% of all arch/ changes since 2.6.34, 
and it's all pointless churn in 

	arch/arm/configs/
	arch/arm/mach-xyz
	arch/arm/plat-blah

and at a certain point in the merge window I simply could not find it in 
me to care about it any more.

Do you guys at all talk about this problem? Have any of the ARM people 
bothered to look at the arch/arm diffs and see how mind-deadening they 
are? I try to look through these kinds of things when I pull, but after a 
million lines of pure noise, it gets old pretty quickly.

Somehow, I can't believe that you need thousands of lines for each random 
arch/arm/mach-xyz (yeah, some very few of them are smaller).

For a taste of the mind-deadening experience, just do

	for i in arch/arm/mach-*
	do
		echo $i; wc -l $(git ls-files $i)
	done | less -S

and imagine being on the receiving side of that.

			Linus
