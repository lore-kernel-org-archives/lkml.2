Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab2HAMnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 08:43:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32326 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab2HAMnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 08:43:07 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=rLFqv8mQjsYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=GT54cWOsR4bT920O4y8A:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1343824983.27983.74.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 1/5] user_hooks: New user hooks subsystem
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 01 Aug 2012 08:43:03 -0400
In-Reply-To: <20120801122821.GA28650@somewhere.redhat.com>
References: <1343403634-31555-1-git-send-email-fweisbec@gmail.com>
	 <1343403634-31555-2-git-send-email-fweisbec@gmail.com>
	 <1343660892.20897.3.camel@twins>
	 <20120730155059.GB17078@somewhere.redhat.com>
	 <20120731070640.GA2950@gmail.com>
	 <20120731104845.GC17078@somewhere.redhat.com>
	 <20120731145742.GA6934@gmail.com> <1343751262.20897.29.camel@twins>
	 <20120801122821.GA28650@somewhere.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-01 at 14:28 +0200, Frederic Weisbecker wrote:
> On Tue, Jul 31, 2012 at 06:14:22PM +0200, Peter Zijlstra wrote:

> So we probably need to generalize a bit more. Some naming based on
> "code domain"?
> 
> struct code_domain {
> 	int is_tracking;
> 	enum {
> 		in_kernel,
> 		in_user,
> 		in_guest
> 	} state;
> }

Is there a fundamental difference between 'in_user' and 'in_guest'
though?


-- Steve


