Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab1LOCYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 21:24:23 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:59800 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947Ab1LOCYW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 21:24:22 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Wed, 14 Dec 2011 21:23:49 -0500
Subject: RE: [PATCH 2/2] trace,x86: Add x86 irq vector entry/exit tracepoints
Thread-Topic: [PATCH 2/2] trace,x86: Add x86 irq vector entry/exit
 tracepoints
Thread-Index: Acy6i6isMFTVbBWGSC68HlD5Abf7ewAMyGwg
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C57F7A90D@USINDEVS01.corp.hds.com>
References: <1311983978-10350-1-git-send-email-vnagarnaik@google.com>
	 <1311983978-10350-3-git-send-email-vnagarnaik@google.com>
	 <5C4C569E8A4B9B42A84A977CF070A35B2C57EE47BC@USINDEVS01.corp.hds.com>
	 <20111213192556.GD2421@somewhere.redhat.com>
	 <5C4C569E8A4B9B42A84A977CF070A35B2C57F7A6D7@USINDEVS01.corp.hds.com>
	 <20111214163407.GE10791@somewhere.redhat.com>
	 <5C4C569E8A4B9B42A84A977CF070A35B2C57F7A805@USINDEVS01.corp.hds.com>
 <1323886185.23971.55.camel@gandalf.stny.rr.com>
In-Reply-To: <1323886185.23971.55.camel@gandalf.stny.rr.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1112140324
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven,

Thank you for giving me an explanation in detail how stacktrace works.
I was confused stacktrace.

>> Rip in local timer interrupt is more accurate information
>> for achieving my goal than stacktrace
>
>Does the above change your mind?



I'm concerned about amount of consumption of ring buffer because
I would like to use a background tracer for multiple cases in our costomer's system
for solving several issues.

As you know, I'm trying to improve tracepoints of signal events with others.
  https://lkml.org/lkml/2011/11/30/223
  
And I'm posting a patch of jbd2 event by myself.
  https://lkml.org/lkml/2011/11/29/328

How much does stacktrace consume ring buffer, compared to a tracepoint?

Seiji


