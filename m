Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab1GETNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 15:13:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41467 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab1GETNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 15:13:30 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=PKUarE_T-c8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=jkkh50-Kq9s2znETBsMA:9 a=PUjeQqilurYA:10 a=8IxOV9yp280A:10 a=akYS_eu778kA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [patch 03/11] blackfin/irqs: Do not trace arch_local_{*,irq_*}
 functions
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <CAMjpGUdFaCEdonJ6s4_gpzSfw+rxzrKcCUwH2xp1zmmAWt8gaw@mail.gmail.com>
References: <20110702030435.308336775@goodmis.org>
	 <20110702033853.220897627@goodmis.org>
	 <CAMjpGUdFaCEdonJ6s4_gpzSfw+rxzrKcCUwH2xp1zmmAWt8gaw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 05 Jul 2011 15:13:27 -0400
Message-ID: <1309893207.26417.179.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-05 at 15:07 -0400, Mike Frysinger wrote:
> On Fri, Jul 1, 2011 at 23:04, Steven Rostedt wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> >
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> for the pedantic/anal, the Author does not match the signed-off-by tag

My patches never do ;)

I author patches to give credit to the company that pays me to write
them. But I rather have people email me to my goodmis.org account,
because I may not see my redhat.com account for a week. I found that
people seem to email me more based on my Signed-off-by than my author
email, so that is the one that I do the goodmis.org account with.

Although, I still get people emailing me to my redhat account every so
often, but they can wait a week for me to respond ;)

-- Steve


