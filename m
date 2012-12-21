Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab2LUSPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 13:15:16 -0500
Received: from fbr04.mfg.siteprotect.com ([64.26.60.139]:39783 "EHLO
	fbr04.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab2LUSPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 13:15:12 -0500
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2012 13:15:12 EST
Date: Fri, 21 Dec 2012 13:07:38 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Jiri Olsa <jolsa@redhat.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/3] perf tool: Add non arch events for SandyBridge
 microarchitecture
In-Reply-To: <20121220111313.GB1241@krava.brq.redhat.com>
Message-ID: <alpine.DEB.2.02.1212211305300.13284@pianoman.cluster.toy>
References: <1355751425-7993-1-git-send-email-jolsa@redhat.com> <1355751425-7993-4-git-send-email-jolsa@redhat.com> <m2zk19d7vk.fsf@firstfloor.org> <20121220111313.GB1241@krava.brq.redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020208.50D4A4F9.00E8,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2012, Jiri Olsa wrote:

> BR_MISP_EXEC.ALL_BRANCHES,event=0x89,umask=0xff
> BR_MISP_EXEC.COND,event=0x89,umask=0x1
> BR_MISP_EXEC.DIRECT_NEAR_CALL,event=0x89,umask=0x10
> BR_MISP_EXEC.INDIRECT_JMP_NON_CALL_RET,event=0x89,umask=0x4
> BR_MISP_EXEC.INDIRECT_NEAR_CALL,event=0x89,umask=0x20
> BR_MISP_EXEC.NONTAKEN,event=0x89,umask=0x40
> BR_MISP_EXEC.RETURN_NEAR,event=0x89,umask=0x8
> BR_MISP_EXEC.TAKEN,event=0x89,umask=0x80
> 

I hate to sound like a broken record here, but, again, what's the 
rationalization for not using libpfm4 here?

Is it simply NIH or is there some sort of technical reason?  It seems a 
lot of wasted effort to create all these tables one chip at a time when 
libpfm4 already has well-tested and debugged event tables for most CPUs 
with perf_event support.

Vince
