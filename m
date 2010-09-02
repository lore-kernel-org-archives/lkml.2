Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab0IBOnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 10:43:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37479 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab0IBOnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 10:43:35 -0400
X-Authority-Analysis: v=1.1 cv=jsU1gHzFqI0vjyg35dbbhFRlpVAv39iqdMS5PbCl9Js= c=1 sm=0 a=4fuILafo2A4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=MzHBENmx867-cuyiZ4QA:9 a=8_T7IK0hESqSglNHcp6p1ek13ZoA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFD][checkpatch] warnings on space in front of labels
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1283437867.2012.213.camel@laptop>
References: <1283437098.2356.135.camel@gandalf.stny.rr.com>
	 <1283437867.2012.213.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 02 Sep 2010 10:43:34 -0400
Message-ID: <1283438614.2356.141.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-02 at 16:31 +0200, Peter Zijlstra wrote:

> > What do others think?
> 
> I'd prefer to run a script over the kernel and remove all those silly spaces.

Until we get a diff option of --ignore-labels as a standard distro diff,
I'd NAK that patch ;-)

-- Steve


