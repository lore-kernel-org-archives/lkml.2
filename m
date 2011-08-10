Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab1HJTQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 15:16:30 -0400
Received: from lo.gmane.org ([80.91.229.12]:33951 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890Ab1HJTQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 15:16:29 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: [patch] perf: ARMv7 wrong "branches" generalized instruction
Date: Wed, 10 Aug 2011 20:16:17 +0100
Message-ID: <yw1xmxfhoz5q.fsf@unicorn.mansr.com>
References: <alpine.DEB.2.00.1108101328440.22769@cl320.eecs.utk.edu>
	<20110810183306.GA32695@e102144-lin.cambridge.arm.com>
	<alpine.DEB.2.00.1108101452510.25186@cl320.eecs.utk.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: unicorn.mansr.com
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Cancel-Lock: sha1:sxt4Hau72B+fQcPZYo4D2SxNF8I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vince Weaver <vweaver1@eecs.utk.edu> writes:

> On Wed, 10 Aug 2011, Will Deacon wrote:
>
>> > It turns out the branches event used (ARMV7_PERFCTR_PC_WRITE) only seems
>> > to count taken branches.
>>
>> It also counts exceptions and instructions that write to the PC.
>
> are those more common than not-taken branches? 

Every function return and every PLT call would fall in this category.

> I'd think branch predictor statistics will be a bit off if only taken
> instructions are measured.

Clearly.

-- 
Måns Rullgård
mans@mansr.com

