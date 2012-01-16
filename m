Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab2APPnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 10:43:16 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:44912 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab2APPnO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 10:43:14 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Mon, 16 Jan 2012 10:42:46 -0500
Subject: RE: [GIT PULL] tracing: make signal tracepoints more useful
Thread-Topic: [GIT PULL] tracing: make signal tracepoints more useful
Thread-Index: AczUYOvv9ZDz8V4FR5ClG/TrEPCHtgABFP4g
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2DA76B3D88@USINDEVS01.corp.hds.com>
References: <20120110174509.GA30802@redhat.com>
 <20120113182015.GA3902@redhat.com> <20120115182441.GA24694@redhat.com>
 <20120116074540.GE15641@elte.hu> <20120116150307.GA12817@redhat.com>
In-Reply-To: <20120116150307.GA12817@redhat.com>
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
 definitions=main-1201160144
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>OK. So we should add the new tracepoint. Looks a bit ugly, but
>I understand your concerns.
>
>
>Say, trace_send_signal(sig, info, t, group, result), OK?
>
>
>Seiji, please double check this is all you need, it won't be
>simply to change this tracepoint again. While we are adding the
>new one, we can add/change something in TP_STRUCT__entry if you
>think this is needed.

I agree to add the new tracepoint as well.
I will review updated patch if you send it.

Seiji
