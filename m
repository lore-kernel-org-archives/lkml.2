Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab0JYXVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 19:21:48 -0400
Received: from claw.goop.org ([74.207.240.146]:49109 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758018Ab0JYXVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 19:21:48 -0400
Message-ID: <4CC61107.4070200@goop.org>
Date: Mon, 25 Oct 2010 16:21:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu,
        xen-devel@lists.xensource.com, tglx@linutronix.de
Subject: Re: [PATCH 1/5] xen: events: use irq_alloc_desc(_at) instead of open-coding
 an IRQ allocator.
References: <1288023736.11153.40.camel@zakaz.uk.xensource.com> <1288023813-31989-1-git-send-email-ian.campbell@citrix.com> <20101025173522.GA5590@dumpdata.com> <4CC60CB7.3070005@goop.org> <4CC60D3A.1020201@zytor.com>
In-Reply-To: <4CC60D3A.1020201@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/25/2010 04:05 PM, H. Peter Anvin wrote:
> On 10/25/2010 04:03 PM, Jeremy Fitzhardinge wrote:
>> What?  Why?  How?  Surely if we're asking the irq subsystem to allocate
>> us an irq, it will return a fresh never-before-used (and certainly not
>> shared) irq?  Shared irqs only make sense if multiple devices are
>> actually sharing, say, a wire on the board.
>>
>> Or am I missing something?
>>
> I think the number is not necessarily "never before used", but rather
> "not currently used".

Yeah, that's what I meant.

    J
