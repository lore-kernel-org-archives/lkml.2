Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab2FLRtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:49:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7002 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab2FLRtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:49:49 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=SOzIsGGhhkgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=OlfiAM2YvjZplSsahZ0A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339523386.13377.135.camel@gandalf.stny.rr.com>
Subject: Re: [RFC PATCHSET 0/3] tools lib traceevent: Generic error handling
 for pevent
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Tue, 12 Jun 2012 13:49:46 -0400
In-Reply-To: <1339486959-25241-1-git-send-email-namhyung@kernel.org>
References: <1339486959-25241-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 16:42 +0900, Namhyung Kim wrote:

> I don't like the name 'pevent' but since it's a part of the API
> so I used it for the name.
> 

Have a better suggestion? It's still a rather new API. We can still
change trace-cmd and power-top if we can come up with a better naming
convention.

Speak now or forever hold your piece ;-) (or is that peace?)

-- Steve




