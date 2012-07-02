Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab2GBPnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 11:43:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14776 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab2GBPnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 11:43:31 -0400
X-Authority-Analysis: v=2.0 cv=AtpsLZBP c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Fhv6DNJ-sIgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=xlAm3tPFCCliDdn7xvgA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1341243809.6578.5.camel@gandalf.stny.rr.com>
Subject: Add to stable: tracing: change CPU ring buffer state from
 tracing_cpumask
From: Steven Rostedt <rostedt@goodmis.org>
To: stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Mon, 02 Jul 2012 11:43:29 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Thomas pointed out that the buffering for tracing (other than function
tracer - and other "tracers") is not affected by the tracing_cpumask.
This goes back to 3.0 (and probably before that).

It's fixed with this commit: 71babb2705e2203a64c27ede13ae3508a0d2c16c
"tracing: change CPU ring buffer state from tracing_cpumask"

Which looks to have made it into 3.5-rc1. Can you apply this to all the
stable trees from 3.0 and beyond.

Thanks,

-- Steve


