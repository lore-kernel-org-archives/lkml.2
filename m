Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268Ab2FOWXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:23:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5300 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758136Ab2FOWXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:23:18 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=ag8JG7z7P3cA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=ynTyILHRb4zuNaQRQaYA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339798996.25903.19.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 3/3] tools lib traceevent: Introduce pevent_strerror
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Date: Fri, 15 Jun 2012 18:23:16 -0400
In-Reply-To: <87pq9043tk.fsf@gmail.com>
References: <1339486959-25241-1-git-send-email-namhyung@kernel.org>
	 <1339486959-25241-4-git-send-email-namhyung@kernel.org>
	 <1339524114.13377.140.camel@gandalf.stny.rr.com>
	 <87ehpj6hic.fsf@sejong.aot.lge.com>
	 <1339730825.13377.311.camel@gandalf.stny.rr.com>
	 <87ipet3pzf.fsf@sejong.aot.lge.com>
	 <1339763129.13377.357.camel@gandalf.stny.rr.com> <87pq9043tk.fsf@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-06-16 at 07:18 +0900, Namhyung Kim wrote:

> So, for now, passing the return value only would be enough. But I think
> passing pevent into a function name started by pevent_ looks natural. :)

Yeah, I agree, and who knows, maybe in the future it will be useful.

Perhaps, we should add a note that says pevent can be NULL. Just in case
you just want to convert a return value and you do not have an available
pevent at hand.

-- Steve


