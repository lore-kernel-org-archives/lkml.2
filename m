Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268Ab2HUSCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 14:02:51 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:49301
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755894Ab2HUSCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 14:02:49 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1202hzzz2dh668h839h944hd25hf0ah11b5h)
X-WSS-ID: 0M94A4E-02-IKF-02
X-M-MSG: 
Date: Tue, 21 Aug 2012 20:02:35 +0200
From: Robert Richter <robert.richter@amd.com>
To: Jiri Olsa <jolsa@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] perf tools: Catch event names from command line
Message-ID: <20120821180235.GD11959@erda.amd.com>
References: <1345144224-27280-1-git-send-email-robert.richter@amd.com>
 <1345144224-27280-6-git-send-email-robert.richter@amd.com>
 <20120820174247.GD1176@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120820174247.GD1176@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.08.12 19:42:47, Jiri Olsa wrote:
> I like the idea of multiple states in parser,
> but parse tests fails:
> 
> [jolsa@krava perf]$ ./perf test -vvv parse
>  5: parse events tests:
> --- start ---
> running test 0 'syscalls:sys_enter_open'
> running test 1 'syscalls:*'
> running test 2 'r1a'
> running test 3 '1:1'
> running test 4 'instructions'
> running test 5 'cycles/period=100000,config2/'
> running test 6 'faults'
> running test 7 'L1-dcache-load-miss'
> running test 8 'mem:0'
> running test 9 'mem:0:x'
> running test 10 'mem:0:r'
> running test 11 'mem:0:w'
> running test 12 'syscalls:sys_enter_open:k'
> running test 13 'syscalls:*:u'
> running test 14 'r1a:kp'
> running test 15 '1:1:hp'
> running test 16 'instructions:h'
> running test 17 'faults:u'
> running test 18 'L1-dcache-load-miss:kp'
> running test 19 'mem:0:u'
> FAILED util/parse-events-test.c:309 wrong name
> ---- end ----
> parse events tests: FAILED!

Right, I need to updated the test cases. Have patches ready for this.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

