Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab0GLI4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 04:56:07 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:35397 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab0GLI4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 04:56:05 -0400
X-AuditID: b753bd60-a7602ba000007d15-0d-4c3ad8a1a6ca
Message-ID: <4C3AD89F.5030006@hitachi.com>
Date: Mon, 12 Jul 2010 17:55:59 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
Cc: Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ian Munsie <imunsie@au.ibm.com>,
        Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH] perf: Add DWARF register lookup for SH
References: <e55812819ad18c2ceca5651ac7698a2af46180d7.1278774279.git.matt@console-pimps.org> <4C3A75E3.6070803@hitachi.com> <87lj9h8bgv.fsf@linux-g6p1.site> <20100712064126.GA3716@linux-sh.org>
In-Reply-To: <20100712064126.GA3716@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> On Mon, Jul 12, 2010 at 07:23:44AM +0100, Matt Fleming wrote:
>> On Mon, 12 Jul 2010 10:54:43 +0900, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>>> Matt Fleming wrote:
>>>> Implement get_arch_regstr() for SH so that, given a DWARF register
>>>> number, the corresponding symbolic name of that register can be looked
>>>> up.
>>> OK, the patch itself looks good, but I don't know whether SH kernel
>>> supports KPROBE_EVENT which is required for perf-probe. Or, SH kernel
>>> repository already has it?
>> No, SH doesn't support KPROBE_EVENT yet. It's on my list of things to
>> do. However, this patch also stops the "DWARF register mappings have not
>> been defined" warning when building perf.
> 
> It does now, by virtue of HAVE_REGS_AND_STACK_ACCESS_API. The initial
> support for this was checked in on June 14th, so you should be able to
> use it already as long as you're working with current HEAD.

Wow, that's great! :)

Thanks!

-- 
Masami HIRAMATSU
2nd Research Dept.
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
