Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab2EHV45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 17:56:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53206 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867Ab2EHV44 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 17:56:56 -0400
Message-ID: <1336514192.8226.52.camel@twins>
Subject: Re: [PATCH] sched: Make nr_uninterruptible count a signed value
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Diwakar Tundlam <dtundlam@nvidia.com>
Cc: "'Ingo Molnar'" <mingo@kernel.org>,
        "'David Rientjes'" <rientjes@google.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Date: Tue, 08 May 2012 23:56:32 +0200
In-Reply-To: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10C@HQMAIL04.nvidia.com>
References: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10C@HQMAIL04.nvidia.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 14:39 -0700, Diwakar Tundlam wrote:
> Declare nr_uninterruptible as a signed long to avoid garbage values
> seen in cat /proc/sched_debug when a task is moved to the run queue of
> a newly online core. This is part of a global counter where only the
> total sum over all CPUs matters.

Its late here, but do explain how any of this makes any difference what
so ever? Since all we do with that field is add/sub the whole sign issue
shouldn't matter one way or the other.


