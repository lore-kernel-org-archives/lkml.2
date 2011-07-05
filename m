Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab1GELtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 07:49:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44931 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559Ab1GELts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 07:49:48 -0400
Date: Tue, 5 Jul 2011 15:49:44 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Don Zickus <dzickus@redhat.com>, Stephane Eranian <eranian@google.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip, final] perf, x86: Add hw_watchdog_set_attr() in a
 sake of nmi-watchdog on P4
Message-ID: <20110705114944.GT17941@sun>
References: <20110705100320.GK17941@sun>
 <20110705102017.GA12458@elte.hu>
 <20110705103403.GN17941@sun>
 <20110705105959.GA14435@elte.hu>
 <20110705110550.GQ17941@sun>
 <20110705112002.GA15654@elte.hu>
 <20110705113620.GS17941@sun>
 <20110705114437.GC15654@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110705114437.GC15654@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 01:44:37PM +0200, Ingo Molnar wrote:
...
> 
> What i am missing is that you have not pointed out the *core problem* 
> you are fixing and it's not obvious from the changelog either!

OK, seems I put there some tech details while human readable changelog
was needed. Will fix that, thanks!

	Cyrill
