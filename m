Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab1BTVPQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 16:15:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34140 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab1BTVPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 16:15:14 -0500
Date: Sun, 20 Feb 2011 22:15:12 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] perf: Optimise topology iteration
Message-ID: <20110220211512.GT5818@one.firstfloor.org>
References: <1298221059.2318.70.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298221059.2318.70.camel@localhost>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 12:57:39AM +0800, Lin Ming wrote:
> Currently we iterate the full machine looking for a matching core_id/nb
> for the percore and the amd northbridge stuff , using a smaller topology
> mask makes sense.

This is still wrong for CPU hotplug. The CPU "owning" the per core
does not necessarily need to be online anymore.
Please drop this patch.

-Andi
