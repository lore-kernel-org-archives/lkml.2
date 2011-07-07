Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab1GGMvD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 08:51:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63336 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285Ab1GGMvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 08:51:00 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=d-1ceqRJjQcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=iec2oK4FaoorbNHwKEUA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: 3.0.0-r5: ftrace: BUG & OOPS
From: Steven Rostedt <rostedt@goodmis.org>
To: Brian Marete <marete@toshnix.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <CAHVUoiRRGY62BZOMYPYxytG569MD0=8=TEN9pCwYefDBg+J+uQ@mail.gmail.com>
References: <CAHVUoiRRGY62BZOMYPYxytG569MD0=8=TEN9pCwYefDBg+J+uQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 07 Jul 2011 08:50:58 -0400
Message-ID: <1310043058.26417.203.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-07 at 13:23 +0300, Brian Marete wrote:
> Hello,
> 
> Testing 3.0.0-5, trying to echo the string '*:mod:radeon' into
> /sys/kernel/debug/tracing/set_ftrace_filter , I get the following BUG
> and Oops:
> 

Crap!

> 
> I am happy to answer any questions.

No, I can trigger it too. I forgot to test the module settings with the
new ftrace code. This is a nasty regression. I'll fix it ASAP.

Thanks!

-- Steve


