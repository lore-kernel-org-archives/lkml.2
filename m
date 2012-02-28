Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab2B1OCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 09:02:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5648 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab2B1OCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 09:02:12 -0500
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=GQe9zCMQTfAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=QQgClDZqAkZQubBoW9gA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1330437729.25686.211.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] trace: Fix build breakage without CONFIG_PERF_EVENTS
From: Steven Rostedt <rostedt@goodmis.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Date: Tue, 28 Feb 2012 09:02:09 -0500
In-Reply-To: <20120228133712.GL3683@opensource.wolfsonmicro.com>
References: <1330426967-17067-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <20120228132159.GA1694@m.brq.redhat.com>
	 <20120228133712.GL3683@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-28 at 13:37 +0000, Mark Brown wrote:
> On Tue, Feb 28, 2012 at 02:21:59PM +0100, Jiri Olsa wrote:
> 
> > what architecture are you on? I wonder how you managed to
> > switch off PERF_EVENTS ;) I tried only x86..
> 
> ARM.  If it was not possible to switch off PERF_EVENTS it shouldn't be a
> config option in the code as this is just creating complexity and
> potential breakage.
> 

It is possible to switch off PERF_EVENTS, just not on x86 :-/

-- Steve


