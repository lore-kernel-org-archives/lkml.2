Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab1BTVRm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 16:17:42 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34148 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab1BTVRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 16:17:41 -0500
Date: Sun, 20 Feb 2011 22:17:40 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] Add support to the perf tool to specify extra values for raw events and pass them to the kernel.
Message-ID: <20110220211740.GU5818@one.firstfloor.org>
References: <1298221040.2318.68.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298221040.2318.68.camel@localhost>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 12:57:20AM +0800, Lin Ming wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> The new format is -e rXXXX[,YYYY]

Need to switch to a different character than , as separate -- 
it's already used for multiple events. Perhaps :

-Andi
