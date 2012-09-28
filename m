Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531Ab2I1PX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 11:23:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38574 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758357Ab2I1PX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 11:23:26 -0400
Date: Fri, 28 Sep 2012 17:23:25 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, acme@redhat.com, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 02/31] perf, x86: Basic Haswell PMU support
Message-ID: <20120928152325.GT16230@one.firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org> <1348806696-31170-3-git-send-email-andi@firstfloor.org> <1348823145.3292.62.camel@twins> <20120928145842.GS16230@one.firstfloor.org> <CABPqkBQ90Crh+EpRQq0Y+xUvrj5vzrX_=SpJQyR4p8uFR_Hr=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQ90Crh+EpRQq0Y+xUvrj5vzrX_=SpJQyR4p8uFR_Hr=Q@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 05:14:18PM +0200, Stephane Eranian wrote:
> But then what happens if I pass a raw value that sets those bits on a
> processor without TSX?

It should be filtered out. It could #GP otherwise. I thought I checked 
that, but will test again.

-Andi
> 
> On Sep 28, 2012 4:58 PM, "Andi Kleen" <andi@firstfloor.org> wrote:

-- 
ak@linux.intel.com -- Speaking for myself only.
