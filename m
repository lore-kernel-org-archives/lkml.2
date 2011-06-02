Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab1FBVB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 17:01:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36256 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab1FBVBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 17:01:55 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=MXrvIagEJvMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=KigzMsGODWPqJd97MpcA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] ftrace: tracepoint of net_dev_xmit sees freed skb and
 causes panic
From: Steven Rostedt <rostedt@goodmis.org>
To: David Miller <davem@davemloft.net>
Cc: sanagi.koki@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, nhorman@tuxdriver.com, mingo@elte.hu,
        fweisbec@gmail.com, mathieu.desnoyers@efficios.com, tglx@linutronix.de,
        kosaki.motohiro@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        kaneshige.kenji@jp.fujitsu.com
In-Reply-To: <20110602.135913.2065173997860104604.davem@davemloft.net>
References: <4DE49D52.709@jp.fujitsu.com>
	 <1306854867.11899.31.camel@gandalf.stny.rr.com>
	 <20110602.135913.2065173997860104604.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 02 Jun 2011 17:01:52 -0400
Message-ID: <1307048512.3667.28.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-02 at 13:59 -0700, David Miller wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> Date: Tue, 31 May 2011 11:14:27 -0400
> 
> > Note, the subject should not be "ftrace:", but "net:" or maybe even
> > "net/tracing", as this really has nothing to do with ftrace code. The
> > tracepoints are more generic than ftrace.
> 
> Do you guys mind if I take this in via the net-2.6 tree?

I have no issue with that. Heck, I prefer it.

-- Steve


