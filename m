Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab1BYMR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 07:17:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:46579 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab1BYMR6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 07:17:58 -0500
Subject: Re: [CFS Bandwidth Control v4 6/7] sched: hierarchical task
 accounting for SCHED_OTHER
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>
In-Reply-To: <AANLkTi=qE-tFox+qGyASmqCwZuvbq0wPH0v0Ai4NJf+O@mail.gmail.com>
References: <20110216031831.571628191@google.com>
	 <20110216031841.352204682@google.com> <1298467931.2217.762.camel@twins>
	 <AANLkTi=qE-tFox+qGyASmqCwZuvbq0wPH0v0Ai4NJf+O@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 25 Feb 2011 13:17:28 +0100
Message-ID: <1298636248.2428.1722.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 19:25 -0800, Paul Turner wrote:
> 
> Yeah I agree :) -- I was planning on fixing this in a follow-up
> [honest!] as it's not as important since it doesn't affect idle
> balancing to the same magnitude.  I wanted to first air the notion of
> hierarchal task accounting in one of the schedulers then mirror the
> support across the other schedulers with consensus reached. 

Right, I think I once argued against this, but the effect on a lot of
things are against me, so lets do this.
