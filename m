Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043Ab2CZRED (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 13:04:03 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46726 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932974Ab2CZREA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 13:04:00 -0400
Message-ID: <1332781439.6160.100.camel@joe2Laptop>
Subject: Re: [PATCH 19/20 v3] sparc/mm/fault_32.c: Port OOM changes to
 do_sparc_fault
From: Joe Perches <joe@perches.com>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: davem@davemloft.net, Paul Gortmaker <paul.gortmaker@windriver.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 26 Mar 2012 10:03:59 -0700
In-Reply-To: <CAFPAmTTAf660w7Xcidzi5KHrJoDSEiWJdOMhyUesGxih8bs1wA@mail.gmail.com>
References: <1332775946-2162-1-git-send-email-consul.kautuk@gmail.com>
	 <1332778595.6160.84.camel@joe2Laptop>
	 <CAFPAmTSyYJkATAD32WqHZY_PdWGjitEq4vgqCZeqjo+V24dh3Q@mail.gmail.com>
	 <1332779529.6160.96.camel@joe2Laptop>
	 <CAFPAmTTAf660w7Xcidzi5KHrJoDSEiWJdOMhyUesGxih8bs1wA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-26 at 12:55 -0400, Kautuk Consul wrote:
> Is it possible to include this kinda checking
> (multiline statements with paranthesis checking assuming tab
> indentation 8) in the
> checkpatch.pl script ?
> It would be easier to not make such mistakes in future with that kind of tool.

Funny you should ask...

Use the latest version of checkpatch and
add the --strict option to the command line.

https://lkml.org/lkml/2012/3/2/15

It works for most cases.

