Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab2LVB4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 20:56:22 -0500
Received: from smtpauth12.mfg.siteprotect.com ([64.26.60.150]:37742 "EHLO
	smtpauth02.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750832Ab2LVB4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 20:56:21 -0500
Date: Fri, 21 Dec 2012 20:58:12 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Andi Kleen <andi@firstfloor.org>
cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/3] perf tool: Add non arch events for SandyBridge
 microarchitecture
In-Reply-To: <20121221184324.GG16230@one.firstfloor.org>
Message-ID: <alpine.DEB.2.02.1212212055120.24063@pianoman.cluster.toy>
References: <1355751425-7993-1-git-send-email-jolsa@redhat.com> <1355751425-7993-4-git-send-email-jolsa@redhat.com> <m2zk19d7vk.fsf@firstfloor.org> <20121220111313.GB1241@krava.brq.redhat.com> <alpine.DEB.2.02.1212211305300.13284@pianoman.cluster.toy>
 <20121221184324.GG16230@one.firstfloor.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020208.50D51343.017C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2012, Andi Kleen wrote:

> > I hate to sound like a broken record here, but, again, what's the 
> > rationalization for not using libpfm4 here?
> 
> Personally I always hated the libpfm4 syntax. It's even worse than
> oprofile.

how so?  The libpfm4 event names are more or less the same as that from 
the manuals with the exception that . is replaced with : in some cases.

> I'm probably biased, but it's usually best to use the format the CPU
> vendor releases the original event tables in. That gives you
> the fastest access with the minimum amount of hazzle.

Which vendors provide "original tables"?  None as far as I know, you are 
stuck digging through PDFs.

Unless you mean the tables that come with Vtune... are those licensed in a 
way that is useful?

libpfm4 also provides at least minimal event descriptions along with each 
event, will the kernel/perf provide those too?

Vince
