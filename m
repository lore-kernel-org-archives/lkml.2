Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933536Ab1FWTwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 15:52:17 -0400
Received: from claw.goop.org ([74.207.240.146]:35153 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932996Ab1FWTwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 15:52:16 -0400
Message-ID: <4E03996B.9050904@goop.org>
Date: Thu, 23 Jun 2011 12:52:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Xen Devel <Xen-devel@lists.xensource.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 09/15] xen/trace: add tlb flush tracepoints
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com> <4db3e32a6b21efdb4d82646816ddb1bb82ff2259.1308607697.git.jeremy.fitzhardinge@citrix.com> <20110621140705.GD28229@dumpdata.com>
In-Reply-To: <20110621140705.GD28229@dumpdata.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2011 07:07 AM, Konrad Rzeszutek Wilk wrote:
>> +TRACE_EVENT(xen_mmu_flush_tlb,
>> +	    TP_PROTO(int x),
>> +	    TP_ARGS(x),
>> +	    TP_STRUCT__entry(__array(char, x, 0)),
>> +	    TP_fast_assign((void)x),
>> +	    TP_printk("%s", "")
> Um, why not just "" without the %s?

Uh, vararg macro bogusness; need to supply 2 args.

    J
