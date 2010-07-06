Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab0GFFLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 01:11:47 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49750 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab0GFFLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 01:11:46 -0400
Date: Tue, 6 Jul 2010 10:34:47 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Chase Douglas <chase.douglas@canonical.com>,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH -tip 0/4] perf-probe updates: string support, etc.
Message-ID: <20100706050447.GG20680@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100519195717.2885.90799.stgit@localhost6.localdomain6>
 <56FC4434-EA6C-4A0C-A95B-3D7BE818774B@canonical.com>
 <20100705174450.GB23506@ghostprotocols.net>
 <4C327D2F.4040807@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4C327D2F.4040807@hitachi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>> Masami Hiramatsu (4):
> >>>      perf probe: Support static and global variables
> >>>      perf probe: Support tracing an entry of array
> >>>      perf probe: Support "string" type
> >>>      tracing/kprobes: Support "string" type
> >> What's the status of these patches? They seem very useful to me, but I
> >> don't see them in Arnaldo's tree at git.kernel.org.
> > 
> > Thanks for reminding me about these ones, will look at them to get them
> > in perf/core.
> 
> Thanks for picking it up. And I need to tell it to Sriker because this
> will affect his uprobes patchset (ftrace part).
> (Actually, my original plan was to update the patchset onto
>  his uprobes patchset.)
> 
> Sriker, the 1st patch in this series will add many macros/functions
> into trace_kprobe.c. This will directly affect your 8th patch of uprobes,
> which splits fetch functions out from trace_kprobe.c.
> Is that OK for you?

Okay, I will keep rebasing to the latest tip/master before sending out
patches for review. So I will continue to do the same when pushing the
v8 patches. 

--
Thanks and Regards
Srikar
