Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab2AYOfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 09:35:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38545 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2AYOfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 09:35:22 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=0Xre1bxECTEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VI20U3BjnhFowqQpYqgA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120125143231.196670014@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 25 Jan 2012 09:32:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Andi Kleen <ak@linux.intel.com>, Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Clark Williams <williams@redhat.com>,
        Luis Goncalves <lgoncalv@redhat.com>
Subject: [PATCH RT 0/2 v2] preempt-rt/x86: Handle sending signals from do_trap() by gdb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated version that cleaned up some of the code and added
some more comments.

If no one has any complaints about these, then I would suggest that they
go into both 3.2-rt as well as the stable 3.0-rt.

Thanks!

-- Steve

