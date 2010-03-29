Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab0C2PxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 11:53:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752338Ab0C2Pw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 11:52:59 -0400
Date: Mon, 29 Mar 2010 08:47:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86 fixes
In-Reply-To: <20100326154354.GA10959@elte.hu>
Message-ID: <alpine.LFD.2.00.1003290844420.3579@i5.linux-foundation.org>
References: <20100326154354.GA10959@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo, what's the state of the "fix CONFIG_NO_BOOTMEM=y" patches? I've seen 
the patches several times, but I've been expecting to pull them from the 
-tip tree rather than apply them directly.

It's mainly the "avoid infinite loop" thing, but Yinghai seems to think 
the three first patches of his (currently 31-patch) series are all 2.6.34 
material.

Ping?

		Linus
