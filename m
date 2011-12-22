Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab1LVQXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 11:23:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57333 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab1LVQXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 11:23:34 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=YtZric0dhrKFnx2a4sYA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1324571011.5916.141.camel@gandalf.stny.rr.com>
Subject: Re: [ANNOUNCE] 3.0.14-rt31
From: Steven Rostedt <rostedt@goodmis.org>
To: Georgiewskiy Yuriy <bottleman@icf.org.ru>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Date: Thu, 22 Dec 2011 11:23:31 -0500
In-Reply-To: <alpine.DEB.2.02.1112221926460.15997@icf.org.ru>
References: <1324525237.5916.114.camel@gandalf.stny.rr.com>
	  <alpine.DEB.2.02.1112221759480.6601@icf.org.ru>
	 <1324565048.5916.139.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.02.1112221926460.15997@icf.org.ru>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-22 at 19:29 +0400, Georgiewskiy Yuriy wrote:
> On 2011-12-22 09:44 -0500, Steven Rostedt wrote Georgiewskiy Yuriy:
> 
> Hi, config in attachment.
> 

I didn't reproduce it. Does it happen all the time? Do you always get
that strange backtrace. If you get something saner, could you print that
out. Could you also send me your full dmesg.

Thanks,

-- Steve


