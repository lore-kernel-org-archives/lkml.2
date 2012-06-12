Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab2FLGmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 02:42:08 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:57609 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab2FLGmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 02:42:06 -0400
X-AuditID: 9c930197-b7b5dae000004b23-8f-4fd6e4ba4be2
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/22] perf tools: Backport of latest changes on trace-cmd's libparseevent
References: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
	<87hauwnash.fsf@sejong.aot.lge.com>
	<20120531145230.GF13591@infradead.org>
	<1338476986.13348.347.camel@gandalf.stny.rr.com>
	<20120531151356.GG13591@infradead.org>
	<20120531152242.GB27841@somewhere.redhat.com>
	<20120531153153.GH13591@infradead.org> <4FD55C2E.1020103@lge.com>
	<20120611141713.GD2202@infradead.org>
Date: Tue, 12 Jun 2012 15:39:04 +0900
In-Reply-To: <20120611141713.GD2202@infradead.org> (Arnaldo Carvalho de Melo's
	message of "Mon, 11 Jun 2012 11:17:13 -0300")
Message-ID: <87txyh5913.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Arnaldo

On Mon, 11 Jun 2012 11:17:13 -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Jun 11, 2012 at 11:47:10AM +0900, Namhyung Kim escreveu:
>> Now I got an account and setup a tree at
>> /pub/scm/linux/kernel/git/namhyung/linux-perf.git. I'll work on
>> further libtraceevent improvement on libtraceeevnt/next branch.
>> 
>> Thanks to all you guys to help me setting this up. :)
>
> Yay! Look forward from pulling from your repository!
>
> Please try to add that Link: thing, for patches that you write you can
> use:
>
> echo Link: http://lkml.kernel.org/n/tip-`ranpwd -l 24`@git.kernel.org
>
> While for patches you collect from other people you should use the
> message-id:
>
> Link: http://lkml.kernel.org/r/$MESSAGE_ID
>

Thanks, I'll do that.
Namhyung

