Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab0DHIGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 04:06:37 -0400
Received: from tundra.namei.org ([65.99.196.166]:41288 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab0DHIGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 04:06:34 -0400
Date: Thu, 8 Apr 2010 18:05:35 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Ingo Molnar <mingo@elte.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       linux-kernel@vger.kernel.org, airlied@linux.ie,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
In-Reply-To: <20100408063236.GA23489@elte.hu>
Message-ID: <alpine.LRH.2.00.1004081805170.25632@tundra.namei.org>
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org> <4BB2EB1B.8090303@zytor.com> <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org> <20100331185916.GA12306@elte.hu> <alpine.LRH.2.00.1004010952080.31957@tundra.namei.org> <4BB3DC4E.7030504@zytor.com>
 <alpine.LRH.2.00.1004011042460.32618@tundra.namei.org> <4BB3DF46.8080008@zytor.com> <alpine.LRH.2.00.1004011200020.365@tundra.namei.org> <20100401125210.GA2445@elte.hu> <20100408063236.GA23489@elte.hu>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Apr 2010, Ingo Molnar wrote:

> ping? Can you or Dave reproduce the bug with -rc3 or later kernels? (If not 
> then it probably means that the bug you triggered was already fixed at the 
> time you reported it, as hpa suspected.)

I haven't seen it since.


- James
-- 
James Morris
<jmorris@namei.org>
