Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab0K1E0P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 23:26:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:32860 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab0K1E0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 23:26:13 -0500
Date: Sat, 27 Nov 2010 23:26:01 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Damien Wyart <damien.wyart@free.fr>, tmhikaru@gmail.com,
        Venkatesh Pallipadi <venki@google.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: High CPU load when machine is idle (related to PROBLEM:
 Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
Message-ID: <20101128042601.GC15818@bombadil.infradead.org>
References: <1288101958.15336.284.camel@twins>
 <1288381343.1988.12.camel@laptop>
 <20101109185516.GQ8332@bombadil.infradead.org>
 <1289329348.2191.69.camel@laptop>
 <20101110034507.GV8332@bombadil.infradead.org>
 <1289390424.2191.98.camel@laptop>
 <20101114051406.GA2050@roll>
 <20101125133106.GA12914@brouette>
 <1290693807.2145.36.camel@laptop>
 <1290888920.32004.1.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290888920.32004.1.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 27, 2010 at 09:15:20PM +0100, Peter Zijlstra wrote:
> > I'll try and get around to it somewhere this week again.
> 
> How does this work for you? Its hideous but lets start simple.
> 

At least one user reports noticeably lower idle load average using a
kernel with that patch.

Thanks, looks promising!

 Kyle
