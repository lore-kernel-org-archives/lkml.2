Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab1AGQOH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 11:14:07 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:39950 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659Ab1AGQOF convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:7:1>);
	Fri, 7 Jan 2011 11:14:05 -0500
Message-Id: <4D2749D6020000780002B0BC@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 07 Jan 2011 16:13:58 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Frederic Weisbecker" <fweisbec@gmail.com>
Cc: "H. Peter Anvin" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
        "Stephane Eranian" <eranian@google.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        "Soeren Sandmann Pedersen" <sandmann@redhat.com>,
        "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] x86: Fix rbp saving in pt_regs on irq
	 entry
References: <4D25EB4B020000780002ABF7@vpn.id2.novell.com>
 <20110106154536.GA2308@nowhere>
 <4D25F79F020000780002AC20@vpn.id2.novell.com>
 <20110106162236.GB2308@nowhere>
 <4D25FE5B020000780002AC50@vpn.id2.novell.com>
 <20110106165452.GC2308@nowhere>
 <4D2602DE020000780002ACA3@vpn.id2.novell.com>
 <20110106171231.GD2308@nowhere>
 <4D26D2C2020000780002AECB@vpn.id2.novell.com>
 <20110107123130.GB20761@elte.hu> <20110107160459.GA2751@nowhere>
In-Reply-To: <20110107160459.GA2751@nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 07.01.11 at 17:05, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> Once I'll have perf callchain based on CFI ready, we'll perhaps find some 
> issues
> there. Although I guess there are already tools that can make use of that.

Is this to read that you're planning to do a re-spin of the CFI
unwinding code (which I'm not allowed to submit another time,
but which we've been using for years in SuSE distros) then?

Jan

