Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab2GJToS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 15:44:18 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34987 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab2GJToQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 15:44:16 -0400
Date: Tue, 10 Jul 2012 22:44:03 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: David Rientjes <rientjes@google.com>
cc: Steven Rostedt <rostedt@goodmis.org>, JoonSoo Kim <js1304@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        Christoph Lameter <cl@linux.com>, Rus <rus@sfinxsoft.com>,
        Ben Hutchings <ben@decadent.org.uk>, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v2] mm, slub: ensure irqs are enabled for kmemcheck
In-Reply-To: <alpine.DEB.2.00.1207091400090.23926@chino.kir.corp.google.com>
Message-ID: <alpine.LFD.2.02.1207102243540.1899@tux.localdomain>
References: <20120708040009.GA8363@localhost> <CAAmzW4OD2_ODyeY7c1VMPajwzovOms5M8Vnw=XP=uGUyPogiJQ@mail.gmail.com> <alpine.DEB.2.00.1207081558540.18461@chino.kir.corp.google.com> <alpine.LFD.2.02.1207091209220.3050@tux.localdomain>
 <alpine.DEB.2.00.1207090333560.8224@chino.kir.corp.google.com> <1341841593.14828.9.camel@gandalf.stny.rr.com> <alpine.DEB.2.00.1207091400090.23926@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2012, David Rientjes wrote:
> kmemcheck_alloc_shadow() requires irqs to be enabled, so wait to disable
> them until after its called for __GFP_WAIT allocations.
> 
> This fixes a warning for such allocations:
> 
> 	WARNING: at kernel/lockdep.c:2739 lockdep_trace_alloc+0x14e/0x1c0()
> 
> Acked-by: Fengguang Wu <fengguang.wu@intel.com>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> Tested-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: David Rientjes <rientjes@google.com>

Applied, thanks!
