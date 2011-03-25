Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab1CYPqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 11:46:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38914 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab1CYPqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 11:46:17 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=PNp5keGnr-sA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=rM3SnFVgasqD5-1YwDEA:9 a=RvBklkRjK087VTbZDhxqsIcbu5cA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCHv3] tracing - avoid soft lockup in trace_pipe
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, fweisbec@gmail.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110325110518.GC1922@jolsa.brq.redhat.com>
References: <20110313145811.GA30558@redhat.com>
	 <1300111651.9910.87.camel@gandalf.stny.rr.com>
	 <20110314141853.GB1936@jolsa.brq.redhat.com>
	 <1300112926.9910.100.camel@gandalf.stny.rr.com>
	 <20110314150746.GA4453@jolsa.brq.redhat.com>
	 <1300116057.9910.106.camel@gandalf.stny.rr.com>
	 <20110314180621.GA5987@jolsa.brq.redhat.com>
	 <20110321121008.GA1979@jolsa.brq.redhat.com>
	 <1301019798.14261.159.camel@gandalf.stny.rr.com>
	 <1301022889.14261.167.camel@gandalf.stny.rr.com>
	 <20110325110518.GC1922@jolsa.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 25 Mar 2011 11:46:16 -0400
Message-ID: <1301067976.14261.190.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 12:05 +0100, Jiri Olsa wrote:

> (while [ 1 ]; do find / > /dev/null ; done) &

Just an FYI,

while :; ... does the same as while [ 1 ]; ...

;)

-- Steve


