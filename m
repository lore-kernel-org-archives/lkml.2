Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab2AJVJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 16:09:30 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:33250 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776Ab2AJVJ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 16:09:29 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 10 Jan 2012 16:09:20 -0500
Subject: RE: [PATCH 0/2] tracing: make signal tracepoints more useful
Thread-Topic: [PATCH 0/2] tracing: make signal tracepoints more useful
Thread-Index: AczPwHME/rwL4k5qRG2C0JaLXLTZ5wAGqbTQ
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C583163CD@USINDEVS01.corp.hds.com>
References: <20120110174509.GA30802@redhat.com>
In-Reply-To: <20120110174509.GA30802@redhat.com>
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
 definitions=main-1201100224
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>Obviously this is the user visible change. But personally I do
>agree with Seiji who requested this feature. Currently
>trace_signal_generate() just records the fact that __send_signal()
>was called, you can't know whether the signal was actually sent
>or not.

We can know behaviors of signal event in detail with this patchset.

Thanks, Oleg.

Seiji



