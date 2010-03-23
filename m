Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab0CWStv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 14:49:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37864 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536Ab0CWStt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 14:49:49 -0400
Date: Tue, 23 Mar 2010 19:49:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/1] perf archive: Explain how to use the generated
 tarball
Message-ID: <20100323184929.GA18815@elte.hu>
References: <1269365638-10223-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269365638-10223-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> [root@doppio ~]# perf archive
> Now please run:
> 
> $ tar xvf perf.data.tar.bz2 -C ~/.debug
> 
> wherever you need to run 'perf report' on.
> [root@doppio ~]#

hm, i think it would be nicer to have a way to both pack and unpack an archive 
that is in the current directory. Something like:

  perf archive pack
  perf archive unpack

or so?

	Ingo
