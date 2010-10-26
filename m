Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555Ab0JZOjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:39:19 -0400
Received: from canuck.infradead.org ([134.117.69.58]:44096 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab0JZOjS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:39:18 -0400
Subject: Re: Clocksource tsc unstable (delta = -8589361717 ns) in current
 git
From: Peter Zijlstra <peterz@infradead.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
In-Reply-To: <20101026135808.GB1672@arch.trippelsdorf.de>
References: <20101026112052.GA1672@arch.trippelsdorf.de>
	 <20101026131843.GC17852@aftab> <20101026135808.GB1672@arch.trippelsdorf.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 26 Oct 2010 16:38:50 +0200
Message-ID: <1288103930.15336.321.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-26 at 15:58 +0200, Markus Trippelsdorf wrote:
> > 
> > This is strange, tsc is actually stable on your F10h revC.
> 
> Yes. constant_tsc is among the CPU flags. 

constant_tsc only means the TSC is not affected by cpu freq changes.

It has zero relevance to cross-cpu sync of the TSC. The clocksource
stuff requires your TSC to be synchronous over all your CPUs.
