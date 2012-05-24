Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab2EXBIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 21:08:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33179 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878Ab2EXBIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 21:08:13 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=P9hwe1c3ElQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=DUF9Yi-w7qjPlpePqMMA:9 a=ANDBhPFR3oFZbzIGirEA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337821690.13348.167.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 00/22] perf tools: Backport of latest changes on
 trace-cmd's libparseevent
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Wed, 23 May 2012 21:08:10 -0400
In-Reply-To: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
References: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 11:36 +0900, Namhyung Kim wrote:
> Hi,
> 
> This is a patchset which attempts to sync what we have on trace-cmd
> into libtraceevent. Although some patch introduced new call-sites of
> die() or malloc_or_die(), it'll be removed eventually (or later work)
> and this helps marking the every locations that we need to track.

Thanks Namhyung!

I would recommend that this patch set be queued for 3.6, with the
following being cherry-picked for 3.5:

 patch 5, 10, 12, 13, 14, 15, 19, and 21

Some of the other patches have fixes for failed allocation. As these
bugs have been around in current perf since forever, they can probably
wait another release before being added. It's not like it will cause the
kernel to crash ;-)

-- Steve


