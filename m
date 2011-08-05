Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab1HEPLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 11:11:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817Ab1HEPLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 11:11:35 -0400
Message-ID: <4E3C0813.5050303@redhat.com>
Date: Fri, 05 Aug 2011 08:11:15 -0700
From: Richard Henderson <rth@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Jason Baron <jbaron@redhat.com>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFT][patch 17/18] sched: use jump labels to reduce overhead
 when bandwidth control is inactive
References: <20110722003211.GA2807@redhat.com>  <CAPM31R+UWijCCna5zYfn875h+KPmS4H0Lk8jW6+8JP-oDb72DA@mail.gmail.com>  <20110722011747.GB2807@redhat.com>  <CAPM31RKW+do-U8G8uL-y53BVWvr4oQbSf456A9u-SUV06tSfeg@mail.gmail.com>  <20110727215816.GA2515@redhat.com> <1312533036.10852.34.camel@twins>
In-Reply-To: <1312533036.10852.34.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2011 01:30 AM, Peter Zijlstra wrote:
> OK, so _WHY_ does that make a difference and will a next version of
> gnu-binutils not mess that up?

The Why is micro-architectual, and I can't answer that.

But ld will never re-order the files as given on the command-line.
There are too many functions and tables that are constructed 
piece-wise from input sections; re-ordering them would change
the semantics of the program.


r~
