Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab2BAVIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:08:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37551 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756985Ab2BAVHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:07:50 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=I-4XTF2Z_QEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VrjHkQLHVd9ilGhJwnQA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120201210612.730595791@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 01 Feb 2012 16:06:12 -0500
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
Subject: [PATCH RT 0/2 v3] preempt-rt/x86: Handle sending signals from do_trap() by gdb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 3 that changes the name of preempt_conditinal_sti/cli() to
conditional_sti/cli_ist(), as discussed between Masami and myself.

-- Steve

