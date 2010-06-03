Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab0FCMvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 08:51:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38939 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab0FCMu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 08:50:58 -0400
Date: Thu, 3 Jun 2010 09:50:35 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Michal Marek <mmarek@suse.cz>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 3/4] perf tools: Make target to generate self contained
	source tarball
Message-ID: <20100603125035.GA29202@ghostprotocols.net>
References: <1275511215-25703-1-git-send-email-acme@infradead.org> <1275511215-25703-4-git-send-email-acme@infradead.org> <87k4qgxzdm.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87k4qgxzdm.fsf@basil.nowhere.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jun 03, 2010 at 11:02:29AM +0200, Andi Kleen escreveu:
> > Arnaldo Carvalho de Melo <acme@infradead.org> writes:
> > Useful for when people want to try some version of the perf tools and don't
> > wants to download the kernel tarball.
> 
> Does this also finally allow to build perf in a separate objdir like
> the rest of the kernel?

This is how I build it:

make O=~/git/build/perf -j9 -C tools/perf install

was done a few months ago, in:

commit c29ede615fd35a640e771fbbb1778e915fac43a7
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Sat Mar 27 14:30:45 2010 -0300

    perf tools: Allow specifying O= to build files in a separate directory
    
    Avoiding polluting the source tree with build files.
    
    Reported-by: Steven Rostedt <rostedt@goodmis.org>
    Cc: Steven Rostedt <rostedt@goodmis.org>
    Cc: Frédéric Weisbecker <fweisbec@gmail.com>
    Cc: Mike Galbraith <efault@gmx.de>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Paul Mackerras <paulus@samba.org>
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

- Arnaldo
