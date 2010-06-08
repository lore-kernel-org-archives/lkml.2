Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab0FHUOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 16:14:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756344Ab0FHUOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 16:14:37 -0400
Date: Tue, 8 Jun 2010 13:14:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michal Simek <michal.simek@petalogix.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] arch/microblaze fixes for 2.6.35-rc3 v2
In-Reply-To: <4C0D3853.60000@petalogix.com>
Message-ID: <alpine.LFD.2.00.1006081313080.4506@i5.linux-foundation.org>
References: <4C0D3853.60000@petalogix.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Jun 2010, Michal Simek wrote:
> 
> here are only fixes for Microblaze. There is no any new features.
> (flush_dcache_page patch fix problem on WB system)
> Just note: Some new patches broke Microblaze arch that's why I would like to
> add at least these patches to your tree.

This _still_ doesn't seem to be "just regressions and major bugfixes for 
things like oopses and security issues".

Why do I even have to send this email?

		Linus
