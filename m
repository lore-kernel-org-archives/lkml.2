Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab2CWNat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 09:30:49 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:52342 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab2CWNas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 09:30:48 -0400
Date: Fri, 23 Mar 2012 14:30:44 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@amd64.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86, mce: Add persistent MCE event
Message-ID: <20120323133044.GA8115@aftab>
References: <1332340496-21658-1-git-send-email-bp@amd64.org>
 <1332340496-21658-3-git-send-email-bp@amd64.org>
 <20120323123156.GF13920@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120323123156.GF13920@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 01:31:56PM +0100, Ingo Molnar wrote:
> Have you considered making the addition of persistent events
> straightforward and robust, in terms of adding a TRACE_EVENT() variant
> for them? It could replace the above code.

Err,

are you thinking of something in TRACE_EVENT() that sets
perf_event_attr.persistent to 1?

Btw, the more important question is are we going to need persistent
events that much so that a generic approach is warranted? I guess maybe
the black box events recording deal would be another user..

IOW, please elaborate :)

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
