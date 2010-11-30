Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab0K3UEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:04:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43256 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab0K3UEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:04:21 -0500
Date: Tue, 30 Nov 2010 15:04:07 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Peter Zijlstra <peterz@infradead.org>, tmhikaru@gmail.com,
        Damien Wyart <damien.wyart@free.fr>,
        Venkatesh Pallipadi <venki@google.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: High CPU load when machine is idle (related to PROBLEM:
 Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
Message-ID: <20101130200407.GC25668@bombadil.infradead.org>
References: <20101114051406.GA2050@roll>
 <20101125133106.GA12914@brouette>
 <1290693807.2145.36.camel@laptop>
 <1290888920.32004.1.camel@laptop>
 <20101128114027.GA2745@brouette>
 <1291030726.32004.4.camel@laptop>
 <20101129194041.GA8280@roll>
 <1291071677.32004.527.camel@laptop>
 <1291129145.32004.874.camel@laptop>
 <20101130153931.GN15818@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101130153931.GN15818@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 10:39:31AM -0500, Kyle McMartin wrote:
> Thanks Peter, I'll build a couple kernels for the bugzilla reporters and
> see what they turn up.
> 

Looks good, one tester says things are promising at least.

Thanks so much for all your effort, Peter.

cheers, Kyle
