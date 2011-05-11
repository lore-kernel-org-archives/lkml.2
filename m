Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab1EKPov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:44:51 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57856 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695Ab1EKPos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:44:48 -0400
Date: Wed, 11 May 2011 15:49:16 +0200
From: Borislav Petkov <bp@amd64.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
Subject: Re: [PATCH 2/2] perf: Carve out callchain functionality
Message-ID: <20110511134916.GC25827@aftab>
References: <1305119816-26280-1-git-send-email-bp@amd64.org>
 <1305119816-26280-3-git-send-email-bp@amd64.org>
 <20110511133009.GA1846@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511133009.GA1846@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 09:30:12AM -0400, Frederic Weisbecker wrote:
> > +extern int get_recursion_context(int *recursion);
> > +extern inline void put_recursion_context(int *recursion, int rctx);
> > +extern void put_callchain_buffers(void);
> > +extern struct perf_callchain_entry *perf_callchain(struct pt_regs *regs);
> > +extern int get_callchain_buffers(void);
> 
> I think it would be better to have these in a private kernel/events/events.h
> 
> Other than that, looks good, thanks.

Yeah, I suggested a new header originally too but Ingo wanted to keep
perf_event.h as is, for now.

> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
