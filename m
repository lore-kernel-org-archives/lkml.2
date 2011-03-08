Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab1CHKrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 05:47:21 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:13268 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab1CHKrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 05:47:19 -0500
X-IronPort-AV: E=Sophos;i="4.62,283,1297036800"; 
   d="scan'208";a="4667316"
Subject: Re: tip tree allows nr_irqs to increase dynamically?
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <alpine.LFD.2.00.1103081030360.2787@localhost6.localdomain6>
References: <1299508939.17339.376.camel@zakaz.uk.xensource.com>
	 <alpine.LFD.2.00.1103081030360.2787@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 8 Mar 2011 10:47:17 +0000
Message-ID: <1299581237.17339.472.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-08 at 09:34 +0000, Thomas Gleixner wrote:
> On Mon, 7 Mar 2011, Ian Campbell wrote:
> 
> > Hi Thomas,
> > 
> > It looks like tip.git irq/core contains patches to allow nr_irqs to
> > expand dynamically. Are these targeted at 2.6.39 or something later?
> 
> 2.6.39

Cool.

> > I'm working on some cleanups to Xen's irq handling and they will
> > require/interact with this new behaviour, is there a suitable commit
> > which I could consider for pulling into my tree to build upon?
> 
> Unfortunately it's the original commit plus a fix which came way
> later, so head of irq/core is the only choice.

That's fine. I'll keep you in the loop with any branches etc I publish
which incorporate this branch.

Ian.

