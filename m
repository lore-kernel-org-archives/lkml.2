Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab1JEUiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 16:38:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60488 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757819Ab1JEUiB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 16:38:01 -0400
Subject: RE: [PATCH 0/8] Online/offline BSP on x86
From: Peter Zijlstra <peterz@infradead.org>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, "Luck, Tony" <tony.luck@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 05 Oct 2011 22:37:47 +0200
In-Reply-To: <493994B35A117E4F832F97C4719C4C040136F7CCBD@orsmsx505.amr.corp.intel.com>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
	 <1317842195.6766.40.camel@twins>
	 <493994B35A117E4F832F97C4719C4C040136F7CC16@orsmsx505.amr.corp.intel.com>
	 <1317842884.6766.45.camel@twins>
	 <493994B35A117E4F832F97C4719C4C040136F7CCBD@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317847067.6766.46.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-05 at 13:29 -0700, Yu, Fenghua wrote:
> > Yes, I got that part. Why do you care?
> 
> I can think of two reasons for bsp offline/online:
> 
> 1. RAS needs the feature. If socket0 needs to be hotplugged for any
> reason (any thread on socket0 is bad, shared cache issue, uncore
> issue, etc), CPU0 is required to be offlined.
> 
Right, this is what I asked.

> 2. CPU0 is symmetrical to other CPU's. There is no specific reason why
> it shouldn't be offlined except BIOS requirements. 

Right, so how are you going to deal with crappy BIOS stuffs? We all know
there's plenty of that around.
