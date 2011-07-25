Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab1GYRhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 13:37:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:50310 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab1GYRhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 13:37:18 -0400
References: <20110721164325.231521704@google.com> <1311605881.24752.2.camel@twins> <1311606041.24752.3.camel@twins> <20110725162133.GI2327@linux.vnet.ibm.com> <1311611311.24752.5.camel@twins> <20110725164619.GK2327@linux.vnet.ibm.com> <1311613694.24752.8.camel@twins> <CAPhKKr-+sss_Q+SLCFWbdQdcCG2rn93Hh8KH7p3eG35AWvsRJQ@mail.gmail.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <CAPhKKr-+sss_Q+SLCFWbdQdcCG2rn93Hh8KH7p3eG35AWvsRJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [patch 00/18] CFS Bandwidth Control v7.2
From: Peter Zijlstra <peterz@infradead.org>
Date: Mon, 25 Jul 2011 19:35:44 +0200
To: Dhaval Giani <dhaval.giani@gmail.com>
CC: paulmck@linux.vnet.ibm.com, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Jason Baron <jbaron@redhat.com>
Message-ID: <488d505f-50ac-47a1-8c89-18b413c33e6a@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dhaval Giani <dhaval.giani@gmail.com> wrote:

>>
>> I consider setting the cgroup paramaters an utter slow path, and if
>> people complain I'll simply tell them to sod off ;-)
>>
>
>cgroups parameters? I can think of some funky uses if setting cgroup
>parameters was not in the slow path. I think you meant create/destroy
>cgroups here :-).
>
>Dhaval

No, i meant writing into cgroup files, like the cfs bandwidth period thing.
-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
