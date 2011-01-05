Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab1AEUKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 15:10:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50268 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303Ab1AEUKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 15:10:19 -0500
Message-ID: <4D24CFD9.20805@zytor.com>
Date: Wed, 05 Jan 2011 12:08:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: David Daney <ddaney@caviumnetworks.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Jason Baron <jbaron@redhat.com>, Ralf Baechle <ralf@linux-mips.org>,
        peterz@infradead.org, mathieu.desnoyers@polymtl.ca, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] jump label: introduce static_branch()
References: <cover.1294239591.git.jbaron@redhat.com> <2d8c38bd7ca93e162aedb8e7acfc8bdb96d85de2.1294239591.git.jbaron@redhat.com> <4D24AB1B.2010209@caviumnetworks.com> <1294249439.26623.35.camel@gandalf.stny.rr.com> <4D24BED1.5000900@zytor.com> <20110105191424.GA7820@elte.hu> <4D24C756.9070302@caviumnetworks.com> <20110105195043.GA9399@elte.hu> <4D24CF95.5090006@caviumnetworks.com>
In-Reply-To: <4D24CF95.5090006@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2011 12:07 PM, David Daney wrote:
> 
> But I am guessing that neither you, nor Linus, regularly build MIPS 
> kernels with GCC-4.5.x *and* jump label support enabled.  So how would 
> such semantic conflict ever be detected?  I would expect the conflict to 
> first occur when Linus pulls Ralf's tree.
> 
> I don't expect anybody to magically fix such things, so whatever 
> happens, I will test it and submit patches if required.
> 

If Ralf knows to expect them, then Ralf can take corrective actions as
he thinks is appropriate.

	-hpa
