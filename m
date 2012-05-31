Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018Ab2EaPJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:09:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22520 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab2EaPJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:09:51 -0400
X-Authority-Analysis: v=2.0 cv=PqgRnnw3 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=P9hwe1c3ElQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=tgiDgJgHMLl4xKPXdRkA:9 a=PUjeQqilurYA:10 a=cEsK4OMRnI3bXlAN:21 a=dxOM7gnlPxyKID_b:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338476986.13348.347.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 00/22] perf tools: Backport of latest changes on
 trace-cmd's libparseevent
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 31 May 2012 11:09:46 -0400
In-Reply-To: <20120531145230.GF13591@infradead.org>
References: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
	 <87hauwnash.fsf@sejong.aot.lge.com> <20120531145230.GF13591@infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 11:52 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, May 31, 2012 at 03:07:26PM +0900, Namhyung Kim escreveu:
> > Hi, Arnaldo
> > 
> > It'd be great if you set up a branch for this so that I can continue to
> > work on it until fully-merged.
> 
> Have you had luck obtaining a git.kernel.org account? It would be better
> if you used git and maintained such branch :-\
> 

Darn it! I wish I signed his key when I had the chance :-p

-- Steve


