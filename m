Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab1DFIPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 04:15:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:38018 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab1DFIPq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 04:15:46 -0400
Subject: Re: [patch 13/15] sched: expire slack quota using generation
 counters
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <BANLkTimOP_EtyxEZ9pOEpgJPqEEic21eCA@mail.gmail.com>
References: <20110323030326.789836913@google.com>
	 <20110323030449.941304760@google.com> <1302010089.2225.1313.camel@twins>
	 <BANLkTimOP_EtyxEZ9pOEpgJPqEEic21eCA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 06 Apr 2011 10:15:32 +0200
Message-ID: <1302077732.2225.1373.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 00:22 -0700, Paul Turner wrote:
> > Argh, this patch is terrible for the reason that it changes the whole
> > accounting just introduced and me having to re-open all the previous
> > patches to look up hth stuff worked before.
> 
> I didn't think it was too drastic -- the introduction of the
> generation is more incremental.  However I agree it does cause
> unnecessary churn within the accounting functions across the series.
> Given that expiring quota is a requirement, this can be streamlined by
> introducing some of these notions earlier in the series as opposed to
> bootstrapping them at the end here -- will clean it up. 

Thanks, and yes, I imagine that when working with the patches for a few
days at end its all not really much of a problem, but for me its the
first look in many weeks and this is the 13th patch in and my brain is
about to turn to mush ;-)

I'll try and read the massive comment on the memory barrier bits once
I've managed to properly wake up..
