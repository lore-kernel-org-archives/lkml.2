Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab0DPLkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 07:40:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39918 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720Ab0DPLkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 07:40:51 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Taras Glek <tglek@mozilla.com>, linux-kernel@vger.kernel.org
Subject: Re: Downsides to madvise/fadvise(willneed) for application startup
From: Andi Kleen <andi@halobates.de>
References: <4BBA6776.5060804@mozilla.com>
	<20100415155309.2649a29b.akpm@linux-foundation.org>
Date: Fri, 16 Apr 2010 13:40:44 +0200
In-Reply-To: <20100415155309.2649a29b.akpm@linux-foundation.org> (Andrew Morton's message of "Thu, 15 Apr 2010 15:53:09 -0700")
Message-ID: <87zl138w1v.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
>
> Yes, the linker scrambles the executable's block ordering.
>
> This just isn't an interesting case.  World-wide, the number of people
> who compile their own web browser and execute it from the file which ld
> produced is, umm, seven.

My understanding was that this is usually gone when you use a delayed
allocation fs (xfs, ext4), unless your link sequence takes much longer
than the flush window.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
