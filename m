Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab1LMSyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 13:54:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:38789 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab1LMSyn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 13:54:43 -0500
Message-ID: <1323802423.9082.21.camel@twins>
Subject: Re: [PATCH 2/2] Add a thread cpu time implementation to vDSO
From: Peter Zijlstra <peterz@infradead.org>
To: Arun Sharma <asharma@fb.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        Kumar Sundararajan <kumar@fb.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        john stultz <johnstul@us.ibm.com>, Andy Lutomirski <luto@MIT.EDU>
Date: Tue, 13 Dec 2011 19:53:43 +0100
In-Reply-To: <4EE7962E.90204@fb.com>
References: <1323718578-1157-1-git-send-email-asharma@fb.com>
	    <1323718578-1157-3-git-send-email-asharma@fb.com>
	   <1323720791.2583.23.camel@edumazet-laptop> <4EE66FE9.1050202@fb.com>
	  <1323725243.2583.27.camel@edumazet-laptop> <4EE67CB5.7000404@fb.com>
	 <1323766358.9082.0.camel@twins> <4EE7962E.90204@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-13 at 10:15 -0800, Arun Sharma wrote:
> On 12/13/11 12:52 AM, Peter Zijlstra wrote:
> > On Mon, 2011-12-12 at 14:14 -0800, Arun Sharma wrote:
> >
> >>> But really most modern distros have NR_CPUS>   64
> >>
> >> Is 256 the new 64? :)
> >
> > 4096 in fact.
> 
> Not sure if you're asking for vsyscall support for NR_CPUS=4096 case or 
> just a compile fix + disabled vsyscall is ok.

I'm saying distros tend to compile with NR_CPUS=4096, so if you
auto-disable the feature for that, it effectively doesn't exist.
