Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab2BCSap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 13:30:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63422 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab2BCSan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 13:30:43 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=DiwmM2OrEz0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=PcDlN1YYXRHnYMXj2pIA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120203182853.547078531@goodmis.org>
User-Agent: quilt/0.50-1
Date: Fri, 03 Feb 2012 13:28:53 -0500
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
Subject: [PATCH RT 0/2 v4] preempt-rt/x86: Handle sending signals from do_trap() by gdb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Can you apply these to v3.2-rt.

Version 4:
 In testing, Clark Williams triggered a bug in the paranoid_exit return
 path. The %rcx register was being clobbered by a function call and
 needed to be restored with: GET_THREAD_INFO(%rcx)

This version has been tested and so far has triggered no bugs.

-- Steve

