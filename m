Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab2FKORW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:17:22 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:62821 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab2FKORU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:17:20 -0400
Date: Mon, 11 Jun 2012 11:17:13 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/22] perf tools: Backport of latest changes on
 trace-cmd's libparseevent
Message-ID: <20120611141713.GD2202@infradead.org>
References: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
 <87hauwnash.fsf@sejong.aot.lge.com>
 <20120531145230.GF13591@infradead.org>
 <1338476986.13348.347.camel@gandalf.stny.rr.com>
 <20120531151356.GG13591@infradead.org>
 <20120531152242.GB27841@somewhere.redhat.com>
 <20120531153153.GH13591@infradead.org>
 <4FD55C2E.1020103@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD55C2E.1020103@lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jun 11, 2012 at 11:47:10AM +0900, Namhyung Kim escreveu:
> Now I got an account and setup a tree at
> /pub/scm/linux/kernel/git/namhyung/linux-perf.git. I'll work on
> further libtraceevent improvement on libtraceeevnt/next branch.
> 
> Thanks to all you guys to help me setting this up. :)

Yay! Look forward from pulling from your repository!

Please try to add that Link: thing, for patches that you write you can
use:

echo Link: http://lkml.kernel.org/n/tip-`ranpwd -l 24`@git.kernel.org

While for patches you collect from other people you should use the
message-id:

Link: http://lkml.kernel.org/r/$MESSAGE_ID

- Arnaldo
