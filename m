Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab1FURLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 13:11:40 -0400
Received: from claw.goop.org ([74.207.240.146]:50720 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab1FURLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 13:11:39 -0400
Message-ID: <4E00D0BD.10509@goop.org>
Date: Tue, 21 Jun 2011 10:11:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Xen Devel <Xen-devel@lists.xensource.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 04/15] xen/trace: add multicall tracing
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com> <a0fe82ae10c0a00c31e60ffacbeec6f49eba93a5.1308607697.git.jeremy.fitzhardinge@citrix.com> <20110621135256.GA28229@dumpdata.com>
In-Reply-To: <20110621135256.GA28229@dumpdata.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2011 06:52 AM, Konrad Rzeszutek Wilk wrote:
>> +TRACE_EVENT(xen_mc_entry,
>> +	    TP_PROTO(struct multicall_entry *mc, unsigned nargs),
>> +	    TP_ARGS(mc, nargs),
>> +	    TP_STRUCT__entry(
>> +		    __field(unsigned short, op)
>> +		    __field(unsigned short, nargs)
>> +		    __array(unsigned long, args, 6)
> Not 'unsigned long' for op?

I wanted to save space in the trace buffer.  I think hypercall numbers
are all small?

    J

