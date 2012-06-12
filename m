Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab2FLR5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:57:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23973 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab2FLR5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:57:41 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=6NGLv67nhmwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=57SyGIRnAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=kwcQnNxcl6P_UFH0E90A:9 a=PUjeQqilurYA:10 a=TIV7c6GJmisA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=LI9Vle30uBYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339523859.13377.137.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/3] tools lib traceevent: Introduce pevent_errno
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Date: Tue, 12 Jun 2012 13:57:39 -0400
In-Reply-To: <1339486959-25241-3-git-send-email-namhyung@kernel.org>
References: <1339486959-25241-1-git-send-email-namhyung@kernel.org>
	 <1339486959-25241-3-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 16:42 +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Define and use error numbers for pevent_parse_event()
> and get rid of die() and do_warning() calls. If the
> function returns non-zero value, the caller can check
> the return code and do appropriate things.
> 
> I chose the error numbers to be negative not to clash
> with standard errno, and as usual, 0 for success.
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

- Steve

> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/lib/traceevent/event-parse.c |   50 +++++++++++++++++++++---------------
>  tools/lib/traceevent/event-parse.h |   26 +++++++++++++++++--
>  2 files changed, 54 insertions(+), 22 deletions(-)
> 


