Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750998Ab2DREAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 00:00:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11632 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab2DREAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 00:00:45 -0400
X-Authority-Analysis: v=2.0 cv=XbcLPfF5 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=_2gBi4Ny9w4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=7aVDFLFgK8XbNmRxKp0A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334721644.28106.30.camel@gandalf.stny.rr.com>
Subject: Re: [3.4-rc3] Thread overran stack, or stack corrupted
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Wed, 18 Apr 2012 00:00:44 -0400
In-Reply-To: <1334721441.28106.28.camel@gandalf.stny.rr.com>
References: <20120417172142.GA30237@redhat.com>
	 <CA+55aFy-uhOgEoEBr-LkOjFQBVh14wwr-20jTrtsg_2EnuNY5g@mail.gmail.com>
	 <20120417203223.GA31699@redhat.com>
	 <CA+55aFzWzhxaVHuPY_oB5PVhw2Gxiwr46vyHCHEsU0o-HFikTw@mail.gmail.com>
	 <20120418022705.GA23877@home.goodmis.org>
	 <20120418031557.GA29828@redhat.com>
	 <1334720611.28106.25.camel@gandalf.stny.rr.com>
	 <20120418035004.GA31465@redhat.com>
	 <1334721441.28106.28.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-17 at 23:57 -0400, Steven Rostedt wrote:

> Also, have you tested to see if function tracing works?
> 
> # cd /sys/kernel/debug/tracing
> # echo function > current_tracer
> # cat trace

Also make sure that the max is zero:

# cat stack_max_size
# echo 0 > stack_max_size

-- Steve


