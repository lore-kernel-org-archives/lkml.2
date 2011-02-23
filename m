Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab1BWU4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:56:38 -0500
Received: from www.tglx.de ([62.245.132.106]:43709 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755815Ab1BWU4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:56:37 -0500
Date: Wed, 23 Feb 2011 21:56:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Metcalf <cmetcalf@tilera.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/3] tile: Cleanup irq chips and irq_desc accessors
In-Reply-To: <4D657405.3050105@tilera.com>
Message-ID: <alpine.LFD.2.00.1102232155460.2701@localhost6.localdomain6>
References: <20110206230305.461141290@linutronix.de> <4D657405.3050105@tilera.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011, Chris Metcalf wrote:

> On 2/6/2011 6:04 PM, Thomas Gleixner wrote:
> > Convert the irq chips to the new callback functions and use proper
> > accessors for irq_desc. Select GENERIC_HARDIRQS_NO_DEPRECATED
> 
> For the series:
> 
> Acked-by: Chris Metcalf <cmetcalf@tilera.com>
> 
> Sorry for the late response, but your email came while I was still trying
> to catch up with my email from a week's vacation, and I'm just re-triaging
> my inbox now :-)

No problem. Can you takes this via your tree for .39 ? It does not
depend on any changes in the core code.

Thanks,

	tglx
