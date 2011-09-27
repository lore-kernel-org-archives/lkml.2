Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab1I0OGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 10:06:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:57209 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab1I0OGd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 10:06:33 -0400
Subject: Re: [PATCH 3/4] trace: add ability to collect call chain of
 non-current task.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Tue, 27 Sep 2011 16:05:51 +0200
In-Reply-To: <1317052535-1765247-4-git-send-email-avagin@openvz.org>
References: <1317052535-1765247-1-git-send-email-avagin@openvz.org>
	 <1317052535-1765247-4-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317132351.15383.66.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-26 at 19:55 +0400, Andrew Vagin wrote:
> 
> Know issues:
> * Now call chains for non-current tasks are collected on x86 only,
>   but it may be done for other architectures simply.
> * It collects only kernel call chains, because we can't get direct
>   access to memory of other processes and this operation should be
>   fast enough. 

Also, it changes the semantics of tracepoint, normally you return the
callchain leading to the tracepoint, this changes that.


I'm not entirely against it, as I can see the use, but I would like to
solicit other opinions.
