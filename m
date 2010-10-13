Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab0JMFTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 01:19:48 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40545 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab0JMFTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 01:19:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 13 Oct 2010 14:14:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
        Mike Waychison <mikew@google.com>, Paul Turner <pjt@google.com>,
        Nikhil Rao <ncrao@google.com>
Subject: Re: [PATCH v3 0/7] CFS Bandwidth Control
Message-Id: <20101013141413.21c13dd9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101012074910.GA9893@in.ibm.com>
References: <20101012074910.GA9893@in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Oct 2010 13:19:10 +0530
Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:

> Hi,
> 
> Its been a while since we posted CPS hard limits (aka CFS bandwidth control
> now) patches, hence a quick recap first:
> 
> - I have been working on CFS hard limits since last year and have posted
>   a few versions of the same (last post: http://lkml.org/lkml/2010/1/5/44)
> - Paul Turner and Nikhil Rao meanwhile started working on CFS bandwidth
>   control and have posted a couple of versions.
>   (last post v2: http://lwn.net/Articles/385055/)
> 
> Paul's approach mainly changed the way the CPU hard limit was represented. After
> his post, I decided to work with them and discontinue my patch series since
> their global bandwidth specification for group appears more flexible than
> the RT-type per-cpu bandwidth specification I had in my series.
> 
> Since Paul seems to be busy, I am taking the freedom of posting the next
> version of his patches with a few enhancements to the slack time handling.
> (more on this later)
> 
Wow, thank you. I've been looking forward to see updates.
I'll try this set.

Regards,
-Kame

