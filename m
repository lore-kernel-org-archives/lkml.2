Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab2HNOax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:30:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25895 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab2HNOav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:30:51 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=dF28KBnHEbwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=nhe7_gQCEjgajjuE_twA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1344954649.6724.13.camel@gandalf.stny.rr.com>
Subject: Using random in interrupts for RT
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ben Hutchings <ben@decadent.org.uk>,
        RT <linux-rt-users@vger.kernel.org>
Date: Tue, 14 Aug 2012 10:30:49 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Ben Hutchings asked me if we still need "genirq: Disable random call on
preempt-rt" for -rt? With commit 902c098a366 "random: use lockless
techniques in the interrupt path" there is no more locks used. But does
it still produce high latencies?

-- Steve


