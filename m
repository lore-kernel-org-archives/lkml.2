Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab2AJJ1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 04:27:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:53349 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab2AJJ1E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 04:27:04 -0500
Message-ID: <1326187602.2442.103.camel@twins>
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Indan Zupancic <indan@nul.nu>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com, len.brown@intel.com,
        anhua.xu@intel.com
Date: Tue, 10 Jan 2012 10:26:42 +0100
In-Reply-To: <0c92071a002c16120b424c4057056a05.squirrel@webmail.greenhost.nl>
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com>
	 <1326103578.2442.50.camel@twins>
	 <20120110001445.GA20542@linux-youquan.bj.intel.com>
	 <1326107563.2442.65.camel@twins>
	 <CAKfTPtDM-L-AcHr_o44vmR9VYRvQqOyXuwEgnZ61d4pbDOPFUg@mail.gmail.com>
	 <1326120367.2442.84.camel@twins>
	 <0c92071a002c16120b424c4057056a05.squirrel@webmail.greenhost.nl>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-10 at 03:12 +0100, Indan Zupancic wrote:
> Perhaps it should be controlled by the CPU governor instead of being
> a separate knob? 

Possibly, Arjan was working on new infrastructure there and we wanted
tighter integration with the scheduler for a number of other reasons as
well, hopefully Arjan will get things sorted soon and show us what it
looks like ;-)
