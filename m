Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab2BHA6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 19:58:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48094 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab2BHA6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 19:58:52 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=A4_-TbpCPcgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=IGYSRg9an36Ql50jUBUA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120208005612.852040607@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 07 Feb 2012 19:56:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Andi Kleen <ak@linux.intel.com>, Oleg Nesterov <oleg@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Luis Goncalves <lgoncalv@redhat.com>
Subject: [PATCH RT 0/2 v5] preempt-rt/x86: Handle sending signals from do_trap() by gdb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, this patch set should be good to go.

Oleg, please take a look at the modifications I made to your patch,
and if you are fine with it, please ack it.

Thomas, this should be the final set (after I get an ack from Oleg)
and hopefully this one can go into -rt.

Thanks!

-- Steve

