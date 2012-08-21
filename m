Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab2HUNua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 09:50:30 -0400
Received: from mail.x86-64.org ([217.9.48.20]:58962 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652Ab2HUNu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 09:50:27 -0400
Date: Tue, 21 Aug 2012 15:50:16 +0200
From: Borislav Petkov <bp@amd64.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH -v2 0/4] Persistent events
Message-ID: <20120821135016.GA23899@aftab.osrc.amd.com>
References: <1345139123-15212-1-git-send-email-bp@amd64.org>
 <1345545050.23018.95.camel@twins>
 <20120821131136.GC21432@aftab.osrc.amd.com>
 <1345556475.5069.3.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345556475.5069.3.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 09:41:15AM -0400, Steven Rostedt wrote:
> Definitely the second one. The first one is just ugly. The second is
> more in line to the tracing directories too:
>
> /debug/tracing/per_cpu/cpu0/...

Maybe I can reuse your code and add

/debug/tracing/per_cpu/cpu0/persistent/<event>

?

It is basically debugfs handling, right? Or are you reworking that
too?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
