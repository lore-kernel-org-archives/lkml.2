Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab0KJN4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 08:56:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36754 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab0KJN4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 08:56:03 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=UWg-Qlbn-4MA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=zeB7-BFqJsCSiuUvVdkA:9 a=Ld9-_sO_eT8qURtQvBQA:7 a=7ibdKvd27kcdexGkkq-fC2dcmh0A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] Delegate unknown module parameters to interested
 parties
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com
In-Reply-To: <201011101621.28946.rusty@rustcorp.com.au>
References: <0d30dc$k4dmjb@orsmga001.jf.intel.com>
	 <1289311867-10096-1-git-send-email-chris@chris-wilson.co.uk>
	 <1289313561.12418.96.camel@gandalf.stny.rr.com>
	 <201011101621.28946.rusty@rustcorp.com.au>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 10 Nov 2010 08:56:00 -0500
Message-ID: <1289397360.12418.119.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 16:21 +1030, Rusty Russell wrote:
> On Wed, 10 Nov 2010 01:09:21 am Steven Rostedt wrote:
> > [ Added Rusty "Module God" Russell ]
> 
> And I also wrote the parameter parsing code, so sending to me is probably
> a good idea.
> 
> So, what's this for?  You want trace= as a standard module parameter

Yep, this way we could even enable tracepoints that are in the init
section.

> or something?  If this is a once-off I'd prefer a custom hack I think.
> If you can think of other users, this might be a good idea; though don't
> use "void *data" use an explicit struct module *...

If I wrote the code, it would have been a once-off custom hack. But,
personally, I like the generic addition. Perhaps others will hook into
it without fear of having to hack the module code, which can be quite
intimidating to some.

I also agree to not use the void *data.

-- Steve


