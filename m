Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab2HOOnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:43:05 -0400
Received: from mail.x86-64.org ([217.9.48.20]:43857 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173Ab2HOOnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:43:03 -0400
Date: Wed, 15 Aug 2012 16:42:55 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH] perf: Let O= makes handle relative paths
Message-ID: <20120815144255.GB15989@aftab.osrc.amd.com>
References: <1344864055.6935.117.camel@gandalf.stny.rr.com>
 <20120813132438.GA18990@aftab.osrc.amd.com>
 <1344867782.6935.119.camel@gandalf.stny.rr.com>
 <20120813142909.GC18990@aftab.osrc.amd.com>
 <20120813180249.GB6840@infradead.org>
 <20120815102722.GB4640@aftab.osrc.amd.com>
 <20120815130634.GE2370@infradead.org>
 <20120815131806.GC4640@aftab.osrc.amd.com>
 <1345041485.31459.89.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345041485.31459.89.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 04:38:05PM +0200, Peter Zijlstra wrote:
> Because you're an idiot and made a typo ;-) Happens to me all the time.

I'm not an idiot - I'm perfection at its purest! :-)

> The regular kernel build doesn't create non-existent O= targets either
> iirc.

Ok, I see. The kernel needs to protect itself against the people who
wrote it :-).

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
