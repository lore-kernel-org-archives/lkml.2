Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab0GAR2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 13:28:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36059 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab0GAR2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 13:28:43 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Frank Mayhar <fmayhar@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 00/52] vfs scalability patches updated
References: <20100624030212.676457061@suse.de>
	<20100630113054.GL24712@dastard> <20100630124049.GH21358@laptop>
	<20100701172317.GB1830@laptop>
Date: Thu, 01 Jul 2010 19:28:34 +0200
In-Reply-To: <20100701172317.GB1830@laptop> (Nick Piggin's message of "Fri, 2
	Jul 2010 03:23:17 +1000")
Message-ID: <87pqz7yuv1.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> writes:
>
> What's that good for? A single threaded, cached `git diff` on the linux
> kernel tree takes just 81% of the time after the vfs patches (0.27s vs
> 0.33s).

That's very cool!

Hopefully we can make some progress on the whole patchkit now.

-Andi
