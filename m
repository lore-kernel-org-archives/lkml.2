Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab1BNTs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:48:27 -0500
Received: from blu0-omc1-s32.blu0.hotmail.com ([65.55.116.43]:11091 "EHLO
	blu0-omc1-s32.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751022Ab1BNTsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:48:25 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP7222F3FA603D8853CF761D96D00@phx.gbl>
Date: Mon, 14 Feb 2011 14:48:20 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
CC: Jason Baron <jbaron@redhat.com>, hpa@zytor.com, rostedt@goodmis.org,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
References: <20110214155113.GA2840@redhat.com> <1297699024.2401.12.camel@twins> <20110214160437.GB2840@redhat.com> <BLU0-SMTP4069A1A89F06CDFF9B28F896D00@phx.gbl> <1297700754.5226.110.camel@laptop> <20110214162947.GA3449@redhat.com> <1297701438.5226.113.camel@laptop> <BLU0-SMTP64371A838030ED92A7CCB696D00@phx.gbl> <20110214185400.GB3449@redhat.com> <1297711209.5226.248.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1297711209.5226.248.camel@laptop>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 14:45:32 up 313 days,  5:35,  7 users,  load average: 2.02, 1.79,
	1.69
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 14 Feb 2011 19:48:24.0658 (UTC) FILETIME=[24451B20:01CBCC80]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Mon, 2011-02-14 at 13:54 -0500, Jason Baron wrote:
> 
> > I don't need an atomic_read() in the disabled case for dynamic debug,
> > and I would be ok, #ifdef CONFIG_JUMP_LABEL, in dynamic_debug.h. Its not
> > the prettiest solution. But I can certainly live with it for now, so
> > that we can sort out the atomic_read() issue independently.
> > 
> > Peter, Mathieu, are you guys ok with this?
> 
> Yeah, lets see where that gets us.
> 

Works for me as long as you put a nice witty comment around this
disgusting hack (something related to "include Hell", where bad
programmers go after they die). ;-)

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
