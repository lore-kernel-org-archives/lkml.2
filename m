Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab0JYXFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 19:05:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46989 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181Ab0JYXFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 19:05:52 -0400
Message-ID: <4CC60D3A.1020201@zytor.com>
Date: Mon, 25 Oct 2010 16:05:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu,
        xen-devel@lists.xensource.com, tglx@linutronix.de
Subject: Re: [PATCH 1/5] xen: events: use irq_alloc_desc(_at) instead of open-coding
 an IRQ allocator.
References: <1288023736.11153.40.camel@zakaz.uk.xensource.com> <1288023813-31989-1-git-send-email-ian.campbell@citrix.com> <20101025173522.GA5590@dumpdata.com> <4CC60CB7.3070005@goop.org>
In-Reply-To: <4CC60CB7.3070005@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2010 04:03 PM, Jeremy Fitzhardinge wrote:
> 
> What?  Why?  How?  Surely if we're asking the irq subsystem to allocate
> us an irq, it will return a fresh never-before-used (and certainly not
> shared) irq?  Shared irqs only make sense if multiple devices are
> actually sharing, say, a wire on the board.
> 
> Or am I missing something?
> 

I think the number is not necessarily "never before used", but rather
"not currently used".

	-hpa
