Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab1KUSjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 13:39:23 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:18933
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755019Ab1KUSjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 13:39:22 -0500
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Nov 2011 13:39:22 EST
X-SpamScore: -13
X-BigFish: VS-13(zz1432N98dK4015Lzz1202hzz8275dhz2dh87h2a8h668h839h8e2h8e3h944h)
X-Forefront-Antispam-Report: CIP:160.36.179.132;KIP:(null);UIP:(null);IPV:NLI;H:kedge1.utk.tennessee.edu;RD:kedge1.utk.tennessee.edu;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 21 Nov 2011 13:24:16 -0500
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: <mingo@redhat.com>, <hpa@zytor.com>, <eranian@google.com>,
        <linux-kernel@vger.kernel.org>, <a.p.zijlstra@chello.nl>,
        <tglx@linutronix.de>, <mingo@elte.hu>
Subject: Re: [tip:perf/urgent] perf/x86: Enable raw event access to Intel
 offcore events
In-Reply-To: <tip-ed13ec58bfe0d5dc95f748e6118432cb0fa283cb@git.kernel.org>
Message-ID: <alpine.DEB.2.00.1111211321390.21667@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1108031200390.703@cl320.eecs.utk.edu> <tip-ed13ec58bfe0d5dc95f748e6118432cb0fa283cb@git.kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Nov 2011, tip-bot for Peter Zijlstra wrote:

> Commit-ID:  ed13ec58bfe0d5dc95f748e6118432cb0fa283cb
> Gitweb:     http://git.kernel.org/tip/ed13ec58bfe0d5dc95f748e6118432cb0fa283cb
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Mon, 14 Nov 2011 10:03:25 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 14 Nov 2011 13:03:44 +0100
> 
> perf/x86: Enable raw event access to Intel offcore events

awesome.  You can add a "Whined-about-it-at-great-length: Vince Weaver"
line to the commit logs if you want.  Now I'll have to find something else 
to complain about, probably the scedulability issue introduced with the
NMI watchdog.

Thanks,

Vince
vweaver1@eecs.utk.edu

