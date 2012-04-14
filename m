Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab2DNQaj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 12:30:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab2DNQai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 12:30:38 -0400
Date: Sat, 14 Apr 2012 13:30:09 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf tools: Fix parsers' rules to dependencies
Message-ID: <20120414163009.GE22114@infradead.org>
References: <1334140791-3024-1-git-send-email-jolsa@redhat.com>
 <tip-024e6c9747bb274c9d744ad52a987a0ebec528a6@git.kernel.org>
 <20120414114129.GF24688@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120414114129.GF24688@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Apr 14, 2012 at 01:41:29PM +0200, Ingo Molnar escreveu:
> 
> * tip-bot for Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > Commit-ID:  024e6c9747bb274c9d744ad52a987a0ebec528a6
> > Gitweb:     http://git.kernel.org/tip/024e6c9747bb274c9d744ad52a987a0ebec528a6
> > Author:     Jiri Olsa <jolsa@redhat.com>
> > AuthorDate: Wed, 11 Apr 2012 12:39:51 +0200
> > Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
> > CommitDate: Wed, 11 Apr 2012 16:57:09 -0300
> > 
> > perf tools: Fix parsers' rules to dependencies
> > 
> > Currently the parsers objects (bison/flex related) are each time perf
> > is built. No matter the generated files are already in place, the
> > parser generation is executed every time.
> > 
> > Changing the rules to have proper flex/bison objects generation
> > dependencies.
> > 
> > The parsers code is not rebuilt until the flex/bison source files
> > are touched. Also when flex/bison source is changed, only dependent
> > objects are rebuilt.
> 
> Hm, can I cherry-pick this over into perf/urgent? I see no good 
> reason why we should leave the v3.4 version half-broken.

Feel free! Overcautious me, wanting to push just only strict bug fixes
there, this one I found just a minor annoyance, so left for perf/core.
 
> Thanks,
> 
> 	Ingo
