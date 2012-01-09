Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab2AIOfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 09:35:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50833 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab2AIOf3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 09:35:29 -0500
Message-ID: <1326119707.2442.77.camel@twins>
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
From: Peter Zijlstra <peterz@infradead.org>
To: svaidy@linux.vnet.ibm.com
Cc: Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com, len.brown@intel.com,
        anhua.xu@intel.com, chaohong.guo@intel.com,
        Youquan Song <youquan.song@linux.intel.com>,
        Paul Turner <pjt@google.com>
Date: Mon, 09 Jan 2012 15:35:07 +0100
In-Reply-To: <20120109110025.GA7988@dirshya.in.ibm.com>
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com>
	 <1326103578.2442.50.camel@twins> <1326104915.2442.53.camel@twins>
	 <20120109110025.GA7988@dirshya.in.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-09 at 16:30 +0530, Vaidyanathan Srinivasan wrote:
> Lets combine the MC/SMT options and create sched_powersavings={0,1,2}
> That will make it only one sysfs knob without any dependencies.
> 
Is there really any sane rationale to keep the 1/2 thing? Why not have a
single boolean knob that says performance/power?
