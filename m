Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab1CBQ1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 11:27:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39135 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab1CBQ1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 11:27:42 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=zBBcF91DTzMA:10 a=IkcTkHD0fZMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=D19gQVrFAAAA:8 a=QiDSsmtYJiiCTwk-2YsA:9 a=QzQeiLU5mLmVMZ7JXq2yVO8TbMQA:4 a=QEXdDO2ut3YA:10 a=Zh68SRI7RUMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH V6 2/2] tracing, perf: add cpu hotplug trace events
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        fweisbec@gmail.com, amit.kucheria@linaro.org, rusty@rustcorp.com.au
In-Reply-To: <20110302095847.GA24111@elte.hu>
References: <AANLkTi=WRo41JprvcEH0Lgc_-j_bTX1MULgJFShV6W9g@mail.gmail.com>
	 <alpine.LFD.2.00.1103021033260.2701@localhost6.localdomain6>
	 <AANLkTikzfNsB=9jQSYrWDEYd3Kd1-d8cVMO79ZqDNt4n@mail.gmail.com>
	 <alpine.LFD.2.00.1103021053480.2701@localhost6.localdomain6>
	 <20110302095847.GA24111@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 11:27:29 -0500
Message-ID: <1299083249.4953.13.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-02 at 10:58 +0100, Ingo Molnar wrote:
> * Thomas Gleixner <tglx@linutronix.de> wrote:

> > > 
> > > I thought that I have answered to your comments :
> > > https://lkml.org/lkml/2011/2/28/203
> > > 
> > > Do I miss something ?
> > 
> > Oops, my bad. I missed that reply somehow. It's not in my inbox. Will
> > dig into my lkml archive then.
> 
> Hm, same here, i only got that reply from lkml, never via direct mail delivery. So 
> something ate the straight path of that mail.

Strange, I got his reply. Perhaps you and Thomas have the same setup
that caused it to be dropped?

-- Steve


