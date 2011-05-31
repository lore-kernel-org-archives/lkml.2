Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab1EaRyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 13:54:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33652 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab1EaRyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 13:54:04 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=MXrvIagEJvMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=uHseGkn7bWEVpJDnyU8A:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] ftrace: tracepoint of net_dev_xmit sees freed skb and
 causes panic
From: Steven Rostedt <rostedt@goodmis.org>
To: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        nhorman@tuxdriver.com, mingo@elte.hu, fweisbec@gmail.com,
        mathieu.desnoyers@efficios.com, tglx@linutronix.de,
        kosaki.motohiro@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        kaneshige.kenji@jp.fujitsu.com
In-Reply-To: <4DE49D52.709@jp.fujitsu.com>
References: <4DE49D52.709@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 31 May 2011 11:14:27 -0400
Message-ID: <1306854867.11899.31.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note, the subject should not be "ftrace:", but "net:" or maybe even
"net/tracing", as this really has nothing to do with ftrace code. The
tracepoints are more generic than ftrace.

-- Steve


