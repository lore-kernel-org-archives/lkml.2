Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848Ab1LNRrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 12:47:08 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:33634 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757776Ab1LNRrF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 12:47:05 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Wed, 14 Dec 2011 12:46:21 -0500
Subject: RE: [PATCH 2/2] trace,x86: Add x86 irq vector entry/exit tracepoints
Thread-Topic: [PATCH 2/2] trace,x86: Add x86 irq vector entry/exit
 tracepoints
Thread-Index: Acy6fjl6io5/6GyKRMG40yRGiFUWeAAAc6nA
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C57F7A805@USINDEVS01.corp.hds.com>
References: <1311983978-10350-1-git-send-email-vnagarnaik@google.com>
 <1311983978-10350-3-git-send-email-vnagarnaik@google.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C57EE47BC@USINDEVS01.corp.hds.com>
 <20111213192556.GD2421@somewhere.redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C57F7A6D7@USINDEVS01.corp.hds.com>
 <20111214163407.GE10791@somewhere.redhat.com>
In-Reply-To: <20111214163407.GE10791@somewhere.redhat.com>
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
 definitions=main-1112140171
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Well ftrace is a whole subsystem that includes the function tracer and also an interface
>for tracepoints in debugfs. I was rather suggesting the latter one. This is a good
>choice for background tracing. And it supports stacktraces. If those generate too much
>overhead perhaps you can tune the number of entries in the stacktrace, I don't remember
>if we can do that currently but this can be an interesting feature.

I would like to periodically check which function call is executed
rather than seeing stacktrace.

AFAIK, purpose of stack tracing is showing where the biggest use of the stack takes place.
I don't think stack tracing achieves my goal.

Rip in local timer interrupt is more accurate information 
for achieving my goal than stacktrace

>
>What are you using currently for the background tracing?

Currently, we are using SystemTap in customer's system.
So, I would like to use this tracepoint with SystemTap.

