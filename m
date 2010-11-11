Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab0KKRFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 12:05:46 -0500
Received: from canuck.infradead.org ([134.117.69.58]:40625 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0KKRFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 12:05:45 -0500
Date: Thu, 11 Nov 2010 12:05:35 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Brian Gitonga Marete <marete@toshnix.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH] [PERF] (Userspace Tools) Fix a compilation error with
 -fstack-protector and -Werror
Message-ID: <20101111170535.GA2203@ghostprotocols.net>
References: <AANLkTinHc7tMntW5NFAhu40RC7m2=HwbqOBeE-21vL8J@mail.gmail.com>
 <20101018233834.GC5370@nowhere>
 <AANLkTi=Ssz4WdMDXq-93GE9bPHoaQ8QyTSrWXDSCa7eH@mail.gmail.com>
 <20101019064000.GC21782@elte.hu>
 <AANLkTimqaTKu23HrgbffAht_Otn9L5k2oHMZDGki8MK+@mail.gmail.com>
 <AANLkTin=0N0b=wK8974RGwXuTxpQ4BtH4bHwjsea+1tS@mail.gmail.com>
 <20101019114904.GB25371@elte.hu>
 <20101019131152.GB3826@ghostprotocols.net>
 <1289471135.17691.1026.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289471135.17691.1026.camel@edumazet-laptop>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Nov 11, 2010 at 11:25:35AM +0100, Eric Dumazet escreveu:
> Hi Arnaldo
> 
> Sorry if I missed something, but current linux-2.6 tree has the problem.
> 
> Is the fix under control ?

Ingo merged this while I'm away, its in tip/urgent.

commit a3da8e451321c31d88cebd12c234d0aac2a1cc35
Author: Cyrill Gorcunov <gorcunov@gmail.com>
Date:   Sat Nov 6 11:47:24 2010 +0300

    perf, ui: Eliminate stack-smashing protection compiler complaint


- Arnaldo
