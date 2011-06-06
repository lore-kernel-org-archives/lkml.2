Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab1FFNZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 09:25:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38554 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab1FFNZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:25:36 -0400
X-Authority-Analysis: v=1.1 cv=rr9DlE2fnT1UeYFJeFag6ks/js+bHNfqVlaSByoS2d4= c=1 sm=0 a=MbabkVIayccA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=FRjYEXmO_ycf1_xor_4A:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: remove noop in pre_schedule_rt()
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTinCbAhE_Zkf393wbtqwu5L0U2jU7w@mail.gmail.com>
References: <BANLkTin1QYAx7as41t78-n0giLSBWoToVA@mail.gmail.com>
	 <BANLkTi=N8cm_9OKk8VCPVxPPn+Ejuhzq6w@mail.gmail.com>
	 <BANLkTinO4p5d-aShHuSOQoPLTCZvAcVjcQ@mail.gmail.com>
	 <1307359563.31814.14.camel@gandalf.stny.rr.com>
	 <BANLkTinCbAhE_Zkf393wbtqwu5L0U2jU7w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 06 Jun 2011 09:25:34 -0400
Message-ID: <1307366734.31814.18.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 21:14 +0800, Hillf Danton wrote:

> The work was repeated not only by Yong, you see, almost
> impossible, which shows RT scheduling was and is
> attracting minds, and will be as well, right?

It was an obvious fix, hardly impossible for it to be done twice. This
happens all the time in the kernel. Especially if for some reason a fix
doesn't make it in. This fix didn't make it in simply because it wasn't
one of my normal branches I push to Ingo, and it was at a time that we
all were quite busy and it was simply overlooked.

But yes, the RT scheduler (and the scheduler itself) always attracts
newcomers, and we welcome them. Nothing curious or unusually about it.

-- Steve


