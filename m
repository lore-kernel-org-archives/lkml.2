Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab1BPQ1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 11:27:30 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:25729 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab1BPQ11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 11:27:27 -0500
X-IronPort-AV: E=Sophos;i="4.60,480,1291611600"; 
   d="scan'208";a="136173122"
Subject: Re: Xen and incorporating event channels in to nr_irqs
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: xen-devel <xen-devel@lists.xensource.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.1102161722290.2701@localhost6.localdomain6>
References: <1297868399.16356.180.camel@zakaz.uk.xensource.com>
	 <alpine.LFD.2.00.1102161638320.2701@localhost6.localdomain6>
	 <1297872739.16356.261.camel@zakaz.uk.xensource.com>
	 <alpine.LFD.2.00.1102161722290.2701@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 16 Feb 2011 16:27:24 +0000
Message-ID: <1297873644.16356.286.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-16 at 16:25 +0000, Thomas Gleixner wrote:
> On Wed, 16 Feb 2011, Ian Campbell wrote:
> > On a vaguely related note, what is the future of non-sparse IRQs (on x86
> > and/or generally)?
> 
> In general I want to switch everything over to SPARSE_IRQ. When the
> open coded access to irq_desc[] is gone, which should be mostly the
> case in .39 then switching everything over should be a smooth
> thing. For those archs which do not want to adjust the numbers
> dynamically we simple allocate NR_IRQS in early_irq_init(). So they
> wont even notice.

Sweet, I won't worry myself unduly over the non-SPARSE_IRQ case then.

Thanks,
Ian.


