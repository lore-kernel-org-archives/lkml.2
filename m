Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814Ab1E0Jum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 05:50:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41272 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867Ab1E0Jul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 05:50:41 -0400
Date: Fri, 27 May 2011 11:50:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: perf: h/w counters not counted and no error/info reported to user
Message-ID: <20110527095036.GK21386@elte.hu>
References: <4DDECFC8.7090903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDECFC8.7090903@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> By default (tip-perf-core) perf-stat enables a number of H/W counters:
> 
> perf stat  -- sleep 1

did you mean to do 'perf stat -a sleep 1' ?

'perf stat sleep 1' in itself will only measure that very simple 
command - which does not do much.

Thanks,

	Ingo
