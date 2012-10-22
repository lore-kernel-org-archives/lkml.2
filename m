Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab2JVNyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:54:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:29075 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041Ab2JVNx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:53:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,630,1344236400"; 
   d="scan'208";a="230636476"
Date: Mon, 22 Oct 2012 06:53:58 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, jolsa@redhat.com
Subject: Re: [PATCH v2 1/2] perf tools: add event modifier to request
 exclusive PMU access
Message-ID: <20121022135358.GJ2095@tassilo.jf.intel.com>
References: <1350912052-10066-1-git-send-email-eranian@google.com>
 <1350912052-10066-2-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350912052-10066-2-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 03:20:51PM +0200, Stephane Eranian wrote:
> This patch adds the x modifier for events. It allows users to
> request exclusive PMU access (attr->exclusive):
> 
> perf stat -e cycles:x ......
> or
> perf stat -e cpu/cycles/x ....
> 
> Exclusive mode is a feature of perf_events which was not yet
> supported by the perf tool. Some events may require exclusive
> PMU access (like on Intel SandyBridge).

You probably should add it also to be readable from sysfs

(like I did with precise in my haswell patchkit)

Then the SNB version of instructions-p can just force this 
without the user having to do anything special.

-Andi
