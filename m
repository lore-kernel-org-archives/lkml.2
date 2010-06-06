Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728Ab0FFDzS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 23:55:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42242 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754225Ab0FFDzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 23:55:17 -0400
Date: Sat, 5 Jun 2010 20:49:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Anholt <eric@anholt.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm-intel changes for 2.6.35-rc1
In-Reply-To: <alpine.LFD.2.00.1006050902160.3593@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1006052048430.3515@i5.linux-foundation.org>
References: <871vcqihj2.fsf@pollan.anholt.net> <alpine.LFD.2.00.1006050902160.3593@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 5 Jun 2010, Linus Torvalds wrote:
> 
> Eric - I want to do an -rc2 later today, and the current intel graphics 
> code has the known problems with cursors not changing right. Can you send 
> me the patch/pull request so that we can get that particular regression 
> fixed before I release -rc2?

Oh well. I didn't hear back, so I just took the patch from the bugzilla 
entry, since I see (saw) the problem myself, and refuse to do an -rc that 
has some bug that affects me and that I can verify personally.

It's commit e7b526bb85.

		Linus
