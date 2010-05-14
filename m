Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab0ENUgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 16:36:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60464 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740Ab0ENUgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 16:36:09 -0400
To: Christoph Lameter <cl@linux.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, npiggin@suse.de
Subject: Re: Defrag in shrinkers
From: Andi Kleen <andi@firstfloor.org>
References: <1273821863-29524-1-git-send-email-david@fromorbit.com>
	<alpine.DEB.2.00.1005141244380.9466@router.home>
Date: Fri, 14 May 2010 22:36:03 +0200
In-Reply-To: <alpine.DEB.2.00.1005141244380.9466@router.home> (Christoph Lameter's message of "Fri\, 14 May 2010 12\:46\:52 -0500 \(CDT\)")
Message-ID: <87y6fmmdak.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <cl@linux.com> writes:

> Would it also be possible to add some defragmentation logic when you
> revise the shrinkers? Here is a prototype patch that would allow you to
> determine the other objects sitting in the same page as a given object.
>
> With that I hope that you have enough information to determine if its
> worth to evict the other objects as well to reclaim the slab page.

I like the idea, it would be useful for the hwpoison code too,
when it tries to clean a page.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
