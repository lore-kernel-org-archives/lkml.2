Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab1LVQPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 11:15:34 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55393 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab1LVQPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 11:15:32 -0500
Date: Thu, 22 Dec 2011 08:15:28 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED 2/2] mempool: fix first round failure behavior
Message-ID: <20111222161528.GF17084@google.com>
References: <20111222001800.GL9213@google.com>
 <20111222001939.GM9213@google.com>
 <20111222004629.GO9213@google.com>
 <20111221170919.f7d49fc6.akpm@linux-foundation.org>
 <20111222012312.GP9213@google.com>
 <20111222151529.GA1388@redhat.com>
 <20111222152009.GB1388@redhat.com>
 <CAOS58YN3hvnXofcz9WVER_bV2KwG+=mqoaJ8zRx2nsoHdpH4wQ@mail.gmail.com>
 <20111222160423.GE1388@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222160423.GE1388@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Thu, Dec 22, 2011 at 11:04:23AM -0500, Vivek Goyal wrote:
> That's a good point. I did not think about module unload. I think then
> my current patch for allocating per cpu object from worker thread is buggy
> as on IO scheduler exit I don't try to flush the possibly in progress
> work[s]. 

Hmmm... I'm not sure whether backporting the mempool stuff would be a
viable approach for this merge window and -stable and we might have to
come up with some kind of minimal solution.  Don't yet know how that
should look like but let's talk about that in a different thread.

Thanks.

-- 
tejun
