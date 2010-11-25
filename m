Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab0KYODU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 09:03:20 -0500
Received: from canuck.infradead.org ([134.117.69.58]:47160 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab0KYODT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 09:03:19 -0500
Subject: Re: High CPU load when machine is idle (related to PROBLEM:
 Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
From: Peter Zijlstra <peterz@infradead.org>
To: Damien Wyart <damien.wyart@free.fr>
Cc: tmhikaru@gmail.com, Venkatesh Pallipadi <venki@google.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101125133106.GA12914@brouette>
References: <1287788622-25860-1-git-send-email-venki@google.com>
	 <1288001573.15336.52.camel@twins> <1288097074.15336.211.camel@twins>
	 <1288101958.15336.284.camel@twins> <1288381343.1988.12.camel@laptop>
	 <20101109185516.GQ8332@bombadil.infradead.org>
	 <1289329348.2191.69.camel@laptop>
	 <20101110034507.GV8332@bombadil.infradead.org>
	 <1289390424.2191.98.camel@laptop> <20101114051406.GA2050@roll>
	 <20101125133106.GA12914@brouette>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 25 Nov 2010 15:03:27 +0100
Message-ID: <1290693807.2145.36.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-25 at 14:31 +0100, Damien Wyart wrote:
> Hi Peter,
> 
> Do you have a plan about solving this problem in the coming weeks or
> will it still be present in 2.6.37 final? I am not implying any critic
> in any way, just want to know a status because compared to other bugs
> discussed in lkml, this one has seen very little technical proposals
> towards a resolution (except your attempts). People who signed off the
> discussed commit did not make any technical analysis about the bug
> reported and this gives a strange feeling. Earth will not stop rotating
> if it is not solved, but I still this it is quite important and affects
> many users. 

Yes I agree, I've put the problem on the back burner for a bit so that I
can forget all my tinkering and try again with a fresher mind :-)

I'll try and get around to it somewhere this week again.
