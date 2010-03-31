Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228Ab0CaVIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 17:08:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752990Ab0CaVID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 17:08:03 -0400
Date: Wed, 31 Mar 2010 14:02:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       linux-kernel@vger.kernel.org, airlied@linux.ie,
       Thomas Gleixner <tglx@linutronix.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
In-Reply-To: <v2m21d7e9971003311357ga4626e41h535ae733933fdc84@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1003311401480.3707@i5.linux-foundation.org>
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org>  <4BB2EB1B.8090303@zytor.com>  <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org>  <20100331185916.GA12306@elte.hu> <v2m21d7e9971003311357ga4626e41h535ae733933fdc84@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Apr 2010, Dave Airlie wrote:
>
> A default y config option causing regressions still at rc3? and you guys
> keep going? This is the sort of shit Linus would flame me for a day or two for,
> 
> Can we get some f'ing consistency here?

Yeah. I think we need to remove the crap.

I thought the problems were known, and fixed in -rc3. Clearly they 
weren't. And by now it's not about changing the default any more - by now 
it's about removing the known-crap code.

		Linus
