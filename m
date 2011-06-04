Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab1FDReg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 13:34:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44135 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab1FDRef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 13:34:35 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=8qa4WLNxHRAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=pKRKc05RFs-kQmU2iS0A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: remove the next highest_prio in RT scheduling
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Yong Zhang <yong.zhang0@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTim+3ZzqBfWNzks96sm89O4o2c2_Yw@mail.gmail.com>
References: <BANLkTimQ67180HxCx5vgMqumqw1EkFh3qg@mail.gmail.com>
	 <1306852804.11899.19.camel@gandalf.stny.rr.com>
	 <BANLkTikzjVd69XRb6psBm1aYSem126YynA@mail.gmail.com>
	 <1307163988.31814.11.camel@gandalf.stny.rr.com>
	 <BANLkTim+3ZzqBfWNzks96sm89O4o2c2_Yw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 04 Jun 2011 13:34:32 -0400
Message-ID: <1307208872.31814.12.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-06-04 at 13:11 +0800, Hillf Danton wrote:
> On Sat, Jun 4, 2011 at 1:06 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> Hi Steve
> 
> Big surprise, you work on Saturday!

Technically Saturday, but I was working late Friday night.

> 
> good weekend

You too.

-- Steve


