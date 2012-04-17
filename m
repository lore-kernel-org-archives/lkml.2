Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab2DQLwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 07:52:37 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:9135 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754551Ab2DQLwg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 07:52:36 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zz9371I936eK1432N98dKzz1202hzz8275dhz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2MGZH-01-6DP-02
X-M-MSG: 
From: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: RE: A quick view of the performance benchmark for semaphore-like
 and mutex
Thread-Topic: A quick view of the performance benchmark for semaphore-like
 and mutex
Thread-Index: Ac0bq8MflXUZwOd4SI6p7+Nhh3anqAALxinAACf1RvD//4nKgP//X4Hw
Date: Tue, 17 Apr 2012 11:52:26 +0000
Message-ID: <491D6B4EAD0A714894D8AD22F4BDE043B15E04@SCYBEXDAG03.amd.com>
References: <491D6B4EAD0A714894D8AD22F4BDE043B15DCF@SCYBEXDAG03.amd.com>
 <1334657569.28150.81.camel@twins>
In-Reply-To: <1334657569.28150.81.camel@twins>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.74.102]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 6:12 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2012-04-17 at 09:36 +0000, Chen, Dennis (SRDC SW) wrote:
>>
>> Interesting!! Semaphore-like is almost 8s slower than mutex... Also, the Events sycles of perf
>> reported is different
>
> I suspect that if you were to use actual semaphores it would be even
> worse, the semaphore implementation doesn't do lock-stealing nor does it
> have fancy assembly fast paths.
>
> In fact, I don't know why you even bother with sems, they're a
> deprecated serialization primitive that really shouldn't be used
> anymore.

Yes, I am also apt to believe that...Actually I never been bothered by sems in my real life, just 
for fun! I enjoy the data :-)

