Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab1ECOhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 10:37:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40220 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab1ECOhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 10:37:38 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=OAku4sAPhKAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=D19gQVrFAAAA:8 a=59TrGsfLputFGiSdmTUA:9 a=yIoDhOLDytWEHtL7PeEA:7 a=PUjeQqilurYA:10 a=b3D6R9wpAFoA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC patch 01/32] TRACE_EVENT: gradual semicolon removal
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <20110503140717.GA29736@Krystal>
References: <20110502211123.163877033@efficios.com>
	 <20110502213211.250108074@efficios.com>  <20110503140717.GA29736@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 03 May 2011 10:37:37 -0400
Message-ID: <1304433457.25414.2399.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 10:07 -0400, Mathieu Desnoyers wrote:
> Hi,
> 
> And here is a self-reply to patch 01/32, due to LKML refusing messages
> with more than 20 recipients.
> 
BTW, next time don't Cc the world on generic patch sets like this. If
someone is Cc'd in one of the patch sets and wonders what it is about.

a) You did not write your change log well enough

b) It contains unrelated changes

c) They could look at lkml.org to find out what this patch set is about.

(c) is what I usually do when I'm Cc'd in a middle of a patch series.

-- Steve


