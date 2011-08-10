Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab1HJTAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 15:00:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46973 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab1HJTAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 15:00:41 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=uD8D-oI69VIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=LXhPem2ZwrCbe_bvu8wA:9 a=kkVxmwVRLkkugFvTdsQA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC PATCH][3.0] Tracepoint: dissociate from module mutex
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, tglx@linutronix.de
In-Reply-To: <20110810180522.GB2988@redhat.com>
References: <20110810174101.GA6523@Krystal>
	 <20110810180522.GB2988@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 10 Aug 2011 15:00:38 -0400
Message-ID: <1313002838.18583.261.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 14:05 -0400, Jason Baron wrote:

> This is similar to the approach we have taken in the jump label code -
> on module insert/remove we store pointers into module table, so that we
> don't require the module_mutex during update time. It has been working
> well there, so this design makes sense to me at least.

It is also similar to what both ftrace and trace events do as well.

-- Steve


