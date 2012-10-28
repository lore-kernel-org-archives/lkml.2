Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab2J1TGA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 15:06:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35797 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102Ab2J1TF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 15:05:58 -0400
Date: Sun, 28 Oct 2012 20:05:51 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, eranian@google.com,
        mingo@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 33/33] perf, tools: List kernel supplied event aliases in perf list v2
Message-ID: <20121028190551.GN16230@one.firstfloor.org>
References: <1351283415-13170-1-git-send-email-andi@firstfloor.org> <1351283415-13170-34-git-send-email-andi@firstfloor.org> <20121027202021.GA9099@krava.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121027202021.GA9099@krava.redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2012 at 10:20:21PM +0200, Jiri Olsa wrote:
> On Fri, Oct 26, 2012 at 01:30:15PM -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > List the kernel supplied pmu event aliases in perf list
> > 
> > It's better when the users can actually see them.
> 
> with the HW events being part of PMU 'events' dir
> we get single HW events listed twice

Cannot change it. Not listing at all is no alternative.

In theory could do a dedup step but I don't think it's worth it.

-Andi
