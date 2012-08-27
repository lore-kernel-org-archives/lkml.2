Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab2H0Uv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 16:51:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:16399 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761Ab2H0Uv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 16:51:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,322,1344236400"; 
   d="scan'208";a="185955162"
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 3/4] perf: teach perf inject to merge sched_stat_* and sched_switch events (v2)
References: <1344344165-369636-1-git-send-email-avagin@openvz.org>
	<1344344165-369636-4-git-send-email-avagin@openvz.org>
Date: Mon, 27 Aug 2012 13:51:02 -0700
In-Reply-To: <1344344165-369636-4-git-send-email-avagin@openvz.org> (Andrew
	Vagin's message of "Tue, 7 Aug 2012 16:56:04 +0400")
Message-ID: <m2ehms6ouh.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Vagin <avagin@openvz.org> writes:
>
> My code saves sched_switch event for each process and when it meets
> stat_iowait, it reports the sched_switch event, because this event
> contains a correct callchain. By another words it replaces all
> stat_iowait events on proper sched_switch events.

Is there any way to generalize this to arbitary events? I found myself
writing scripts to compute lengths between various events.  But I
presume this could be done in a more general way. The advantage
of perf-inject over my script is that the output can be viewed
in the normal browser.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
