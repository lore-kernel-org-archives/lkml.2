Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab0JTNar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 09:30:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:44118 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab0JTNaq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 09:30:46 -0400
Subject: Re: High CPU load when machine is idle (related to PROBLEM:
 Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
From: Peter Zijlstra <peterz@infradead.org>
To: Damien Wyart <damien.wyart@free.fr>
Cc: Chase Douglas <chase.douglas@canonical.com>, Ingo Molnar <mingo@elte.hu>,
        tmhikaru@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101020132732.GA30024@brouette>
References: <20100929070153.GA2200@brouette>
	 <20101014145813.GA2185@brouette>  <20101020132732.GA30024@brouette>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 20 Oct 2010 15:30:40 +0200
Message-ID: <1287581440.3488.16.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 15:27 +0200, Damien Wyart wrote:
> 
> Should'nt we enlarge the list of CC, because for now, responsivity has
> been close to 0 and it seems we will get a 2.6.36 with buggy load avg
> calculation. Even if it is only statistics, many supervision tools rely
> on the load avg, so for production environments, this is not a good
> thing. 

It already contains all the folks who know the code I'm afraid.. :/

I've been playing with it a bit more today, but haven't actually managed
to make it better, just differently worse..
