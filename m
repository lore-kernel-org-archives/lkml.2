Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab0FGSAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:00:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751044Ab0FGSAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:00:45 -0400
Date: Mon, 7 Jun 2010 10:54:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michal Simek <monstr@monstr.eu>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] arch/microblaze fixes for 2.6.35-rc3
In-Reply-To: <4C0CF9DF.2050603@monstr.eu>
Message-ID: <alpine.LFD.2.00.1006071052410.3515@i5.linux-foundation.org>
References: <4C0CF9DF.2050603@monstr.eu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Jun 2010, Michal Simek wrote:
> 
> please pull the following changes.

No. See my -rc2 announcement. Also, this has clearly not even been tested, 
since it's been rebased on top of a recent commit.

So I'm being a hard-ass this time around. I don't care what subsystem it 
is, I want pull requests to follow the after-merge-window rules. 
Regressions, security bugs, and major oopses. Not just random changes.

			Linus
