Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab0KJDpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 22:45:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42736 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab0KJDpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 22:45:19 -0500
Date: Tue, 9 Nov 2010 22:45:07 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Venkatesh Pallipadi <venki@google.com>,
        Damien Wyart <damien.wyart@free.fr>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, tmhikaru@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: High CPU load when machine is idle (related to PROBLEM:
 Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
Message-ID: <20101110034507.GV8332@bombadil.infradead.org>
References: <AANLkTin+HE09Oui89uCmG-rrHE14zXfJuRvZgsPCB1De@mail.gmail.com>
 <1287788622-25860-1-git-send-email-venki@google.com>
 <1288001573.15336.52.camel@twins>
 <1288097074.15336.211.camel@twins>
 <1288101958.15336.284.camel@twins>
 <1288381343.1988.12.camel@laptop>
 <20101109185516.GQ8332@bombadil.infradead.org>
 <1289329348.2191.69.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289329348.2191.69.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 08:02:28PM +0100, Peter Zijlstra wrote:
> Right, I tested it myself yesterday and got similar results. Does the
> 'simple' patch from a few posts back work for people?
>

Apparently it doesn't make a large amount of difference. :/

regards, Kyle
