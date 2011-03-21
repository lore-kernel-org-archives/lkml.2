Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab1CUN3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 09:29:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39874 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1CUN3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 09:29:18 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=d6KjmF4z1lEA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=3lZFYKBB-HEbCBkL8dsA:9 a=ZhRhQ7CGc7iq3MyYNOa9soYiltkA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] checkpatch: Test for kmalloc/memset(0) pairs
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>, LKML <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@shadowen.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1300713980.16880.5813.camel@gandalf.stny.rr.com>
References: <1300416744.16880.904.camel@gandalf.stny.rr.com>
	 <20110317211548.646b04d2@tpl.lwn.net>  <20110319193954.GA2032@redhat.com>
	 <1300713980.16880.5813.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 21 Mar 2011 09:29:17 -0400
Message-ID: <1300714157.16880.5819.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, there seems to be one important thing missing from this thread.
Can we please apply my patch?

It may be months or years before we decide how to handle this checkpatch
vs Coccinelle and I think it is important that we flag this as a
warning/error.

-- Steve


