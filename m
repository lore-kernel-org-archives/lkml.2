Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab0GLIOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 04:14:14 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:35176 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751018Ab0GLION (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 04:14:13 -0400
Date: Mon, 12 Jul 2010 09:14:12 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ian Munsie <imunsie@au.ibm.com>,
        Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH] perf: Add DWARF register lookup for SH
Message-ID: <20100712081412.GA30130@console-pimps.org>
References: <e55812819ad18c2ceca5651ac7698a2af46180d7.1278774279.git.matt@console-pimps.org> <4C3A75E3.6070803@hitachi.com> <87lj9h8bgv.fsf@linux-g6p1.site> <20100712064126.GA3716@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100712064126.GA3716@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 03:41:26PM +0900, Paul Mundt wrote:
> On Mon, Jul 12, 2010 at 07:23:44AM +0100, Matt Fleming wrote:
> > 
> > No, SH doesn't support KPROBE_EVENT yet. It's on my list of things to
> > do. However, this patch also stops the "DWARF register mappings have not
> > been defined" warning when building perf.
> 
> It does now, by virtue of HAVE_REGS_AND_STACK_ACCESS_API. The initial
> support for this was checked in on June 14th, so you should be able to
> use it already as long as you're working with current HEAD.

Oh, whoops, I must have been thinking of something else. Thanks Paul!
