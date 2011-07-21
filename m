Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab1GUMCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 08:02:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:55172 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab1GUMCu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 08:02:50 -0400
Subject: Re: [PATCH -tip/perf/core] perf, x86: P4 PMU - Introduce event
 alias feature
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, Don Zickus <dzickus@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20110721064610.GB26260@elte.hu>
References: <20110708201712.GS23657@sun>  <20110721064610.GB26260@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 21 Jul 2011 14:02:18 +0200
Message-ID: <1311249738.29152.123.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-21 at 08:46 +0200, Ingo Molnar wrote:
> 
> This looks like the right approach otherwise. Peter? 

Yeah, aliases are cool :-)
