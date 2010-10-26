Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab0JZIPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 04:15:53 -0400
Received: from smtp.citrix.com ([66.165.176.89]:47204 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414Ab0JZIPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 04:15:52 -0400
X-IronPort-AV: E=Sophos;i="4.58,240,1286164800"; 
   d="scan'208";a="10807017"
Subject: Re: [Xen-devel] Re: [PATCH 1/5] xen: events: use
 irq_alloc_desc(_at) instead of open-coding an IRQ allocator.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>
In-Reply-To: <1288029736.10179.35.camel@localhost.localdomain>
References: <1288023736.11153.40.camel@zakaz.uk.xensource.com>
	 <1288023813-31989-1-git-send-email-ian.campbell@citrix.com>
	 <20101025173522.GA5590@dumpdata.com>
	 <1288029736.10179.35.camel@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Tue, 26 Oct 2010 09:15:48 +0100
Message-ID: <1288080948.10179.57.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 19:02 +0100, Ian Campbell wrote:
> 
> 
> > What do you see when you pass in a PCI device and say give the guest
> 32 CPUs??
> 
> I can try tomorrow and see, based on what you say above without
> implementing what I described I suspect the answer will be "carnage". 

Actually, it looks like multi-vcpu is broken, I only see 1 regardless of
how many I configured. It's not clear if this is breakage in Linus'
tree, something I pulled in from one of Jeremy's, yours or Stefano's
trees or some local pebcak. I'll investigate...

Ian.


