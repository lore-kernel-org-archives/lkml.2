Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab2A0KpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 05:45:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35509 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab2A0KpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 05:45:05 -0500
Date: Fri, 27 Jan 2012 11:44:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: =?iso-8859-1?B?TOluYe9j?= Huard <lenaic@lhuard.fr.eu.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: Shift by one instruction in the perf annotate output
Message-ID: <20120127104442.GB31782@elte.hu>
References: <201201270001.27765.lenaic@lhuard.fr.eu.org>
 <1327652120.2446.123.camel@twins>
 <20120127102741.GA31782@elte.hu>
 <1327660811.2446.155.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327660811.2446.155.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2012-01-27 at 11:27 +0100, Ingo Molnar wrote:
>
> > On Core2 CPUs there's PEBS so 'p' will work, but there's no 
> > LBR so the IP-rewinding does not work.
> 
> Not on his thing.. PEBS is a trainwreck on model 15.

ok - i have a model 23, there it works:

[    0.044260] CPU0: Intel(R) Core(TM)2 Duo CPU     T9600  @ 2.80GHz stepping 06
[    0.044996] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.

Thanks,

	Ingo
