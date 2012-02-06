Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab2BFU2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 15:28:01 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:58687 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab2BFU2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 15:28:00 -0500
Date: Mon, 6 Feb 2012 21:27:22 +0100
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        acme@redhat.com, mingo@elte.hu, robert.richter@amd.com,
        eric.dumazet@gmail.com, Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [BUG] perf: perf sched warning possibly due to clock granularity
 on AMD
Message-ID: <20120206202722.GA556@aftab>
References: <20120206132546.GA30854@quad>
 <1328538403.2482.4.camel@laptop>
 <20120206153408.GA31237@aftab>
 <1328546246.2482.10.camel@laptop>
 <20120206164626.GA31704@aftab>
 <1328547259.2482.11.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328547259.2482.11.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 05:54:19PM +0100, Peter Zijlstra wrote:
> On Mon, 2012-02-06 at 17:46 +0100, Borislav Petkov wrote:
> > > across all CPUs in the entire system.
> > 
> > Right, by the "entire system" you mean consistent across cores and
> > sockets but not necessarily across cabinets, as in the comment above,
> > correct?
> > 
> > If so, let me ask around if this holds true too.
> 
> Every CPU available to the kernel. So if you run a single system image
> across your cabinets, then yes those too.

Ok, but what about that sentence "(but not across cabinets - we turn
it off in that case explicitly.)" - I don't see any place where it is
turned off explicitly... Maybe a stale comment?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
