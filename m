Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab0GLGXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 02:23:48 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:59404 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752145Ab0GLGXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 02:23:47 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ian Munsie <imunsie@au.ibm.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] perf: Add DWARF register lookup for SH
In-Reply-To: <4C3A75E3.6070803@hitachi.com>
References: <e55812819ad18c2ceca5651ac7698a2af46180d7.1278774279.git.matt@console-pimps.org> <4C3A75E3.6070803@hitachi.com>
User-Agent: Notmuch/0.3.1-61-g3f63bb6 (http://notmuchmail.org) Emacs/23.1.90.2 (x86_64-unknown-linux-gnu)
Date: Mon, 12 Jul 2010 07:23:44 +0100
Message-ID: <87lj9h8bgv.fsf@linux-g6p1.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010 10:54:43 +0900, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> Matt Fleming wrote:
> > Implement get_arch_regstr() for SH so that, given a DWARF register
> > number, the corresponding symbolic name of that register can be looked
> > up.
> 
> OK, the patch itself looks good, but I don't know whether SH kernel
> supports KPROBE_EVENT which is required for perf-probe. Or, SH kernel
> repository already has it?

No, SH doesn't support KPROBE_EVENT yet. It's on my list of things to
do. However, this patch also stops the "DWARF register mappings have not
been defined" warning when building perf.
