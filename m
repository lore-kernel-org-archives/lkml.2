Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab1CHJfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 04:35:05 -0500
Received: from www.tglx.de ([62.245.132.106]:37703 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709Ab1CHJe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 04:34:58 -0500
Date: Tue, 8 Mar 2011 10:34:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ian Campbell <Ian.Campbell@citrix.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: tip tree allows nr_irqs to increase dynamically?
In-Reply-To: <1299508939.17339.376.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.LFD.2.00.1103081030360.2787@localhost6.localdomain6>
References: <1299508939.17339.376.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Mar 2011, Ian Campbell wrote:

> Hi Thomas,
> 
> It looks like tip.git irq/core contains patches to allow nr_irqs to
> expand dynamically. Are these targeted at 2.6.39 or something later?

2.6.39
 
> I'm working on some cleanups to Xen's irq handling and they will
> require/interact with this new behaviour, is there a suitable commit
> which I could consider for pulling into my tree to build upon?

Unfortunately it's the original commit plus a fix which came way
later, so head of irq/core is the only choice.

Thanks,

	tglx
