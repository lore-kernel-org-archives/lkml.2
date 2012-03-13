Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab2CMPYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 11:24:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59221 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755565Ab2CMPYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 11:24:32 -0400
Date: Tue, 13 Mar 2012 16:24:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung.kim@lge.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf report: Treat an argument as a symbol filter
Message-ID: <20120313152417.GA12193@elte.hu>
References: <1331619294-29162-1-git-send-email-namhyung.kim@lge.com>
 <1331619294-29162-4-git-send-email-namhyung.kim@lge.com>
 <20120313062105.GB24357@elte.hu>
 <1331646021.18960.71.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331646021.18960.71.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2012-03-13 at 07:21 +0100, Ingo Molnar wrote:
> > To play the devil's advocate it uses up valuable perf report 
> > command line real estate and we probably cannot change this 
> > workflow in the future, once people get used to it. 
> 
> I would indeed suggest to make it a proper argument and add 
> argument parsing to report like we have for all the other 
> commands.
> 
> Say something like: perf report --symbol-filter="foobar" and 
> maybe an appropriate short version.

No objection against also having a command line option, but I 
really like the Git way of doing things like:

   git remote update tip

where it's several layers of commands plus arguments, with no 
silly command switch names to remember.

Thanks,

	Ingo
