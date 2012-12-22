Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab2LVRFx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 12:05:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10516 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab2LVRFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 12:05:50 -0500
X-Authority-Analysis: v=2.0 cv=O9a7TWBW c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=eZnsvP3-SpoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=om32Zw-ELMQA:10 a=ImJolIsyp5_pLRy3UgMA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1356195947.5896.125.camel@gandalf.local.home>
Subject: Re: [PATCH 07/24] nohz: Assign timekeeping duty to a non-full-nohz
 CPU
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 22 Dec 2012 12:05:47 -0500
In-Reply-To: <CAFTL4hxSMmu5h1=yVK1qn6NNVYF3WfTZYxPxPTJ=xzibgpkayQ@mail.gmail.com>
References: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
	 <1356028391-14427-8-git-send-email-fweisbec@gmail.com>
	 <1356106396.5896.111.camel@gandalf.local.home>
	 <CAFTL4hxSMmu5h1=yVK1qn6NNVYF3WfTZYxPxPTJ=xzibgpkayQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-12-22 at 17:39 +0100, Frederic Weisbecker wrote:

> Ah thanks! I'm folding your patch.
> I can add your SOB, right?

Sure, feel free to add my SOB on any of the changes I sent to you.

-- Steve


