Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733Ab0CPIrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 04:47:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59410 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696Ab0CPIr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 04:47:29 -0400
Date: Tue, 16 Mar 2010 09:47:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: T??r??k Edwin <edwintorok@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: fix callgraphs of 32-bit processes on 64-bit kernels.
Message-ID: <20100316084714.GB7961@elte.hu>
References: <1268667260-5505-1-git-send-email-edwintorok@gmail.com>
 <4B9E5EFF.1080308@gmail.com>
 <4B9F3EEC.7050104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9F3EEC.7050104@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* T??r??k Edwin <edwintorok@gmail.com> wrote:

> On 03/15/2010 06:23 PM, T??r??k Edwin wrote:
> > On 03/15/2010 05:34 PM, T??r??k Edwin wrote:
> >>
> >> It would be good if perf knew how to lookup symbols in kernel modules!
> > 
> > BTW perf report -m -k /home/edwin/builds/linux-2.6/vmlinux doesn't show
> > the symbols either.
> 
> I always forget that, unlike every other program, perf doesn't install
> by default to /usr/local!
> So I was running the wrong version of perf (from an older kernel), since
> perf was installed to $HOME/bin (which of course isn't in sudo's path).
> 
> Sorry for the confusion, the 2.6.33 perf DOES know how to lookup the
> symbols:
>     9.92%  glxgears  [radeon]                           [k]
> r600_packet3_check
>             |
>             --- r600_packet3_check
>                |
>                |--96.80%-- r600_cs_parse

Ok, great!

I suspect we could install into /usr/local too. Do you want to send a patch 
for that?

	Ingo
