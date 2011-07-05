Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab1GEOlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:41:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36513 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab1GEOlL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:41:11 -0400
Subject: Re: [PATCH -tip, final] perf, x86: Add hw_watchdog_set_attr() in a
 sake of nmi-watchdog on P4
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Stephane Eranian <eranian@google.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110705133105.GB5843@elte.hu>
References: <20110705103403.GN17941@sun> <20110705105959.GA14435@elte.hu>
	 <20110705110550.GQ17941@sun> <20110705112002.GA15654@elte.hu>
	 <20110705113620.GS17941@sun> <20110705114437.GC15654@elte.hu>
	 <20110705114944.GT17941@sun> <20110705121421.GU17941@sun>
	 <20110705131005.GA5843@elte.hu> <1309871841.3282.148.camel@twins>
	 <20110705133105.GB5843@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 05 Jul 2011 16:40:51 +0200
Message-ID: <1309876851.3282.235.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-05 at 15:31 +0200, Ingo Molnar wrote:
> So there's lots of options to fix/improve this more intelligently.

Sure, and I like the alternative encoding thing best, but doing that
will take time, in the meantime this patch, which is relatively small
(and easy to revert once we get something better going) does fix a
problem for those few unfortunate souls still using P4 hardware.
