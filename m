Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720Ab2GBJCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 05:02:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:44201 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449Ab2GBJCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 05:02:42 -0400
Date: Mon, 2 Jul 2012 11:02:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Iyer, Sundar" <sundar.iyer@intel.com>
cc: Paul Mundt <lethal@linux-sh.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "Monroy, German" <german.monroy@intel.com>
Subject: RE: [PATCH v3 1/1] x86/irq: handle chained interrupts during IRQ
 migration
In-Reply-To: <2FABAEF0D3DCAF4F9C9628D6E2F9684521253F@BGSMSX102.gar.corp.intel.com>
Message-ID: <alpine.LFD.2.02.1207021101460.2793@ionos>
References: <1340596507-12702-1-git-send-email-sundar.iyer@intel.com> <20120625053156.GB24033@linux-sh.org> <2FABAEF0D3DCAF4F9C9628D6E2F9684521253F@BGSMSX102.gar.corp.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2012, Iyer, Sundar wrote:

> Hi Thomas/Paul,
> 
> Any comments on the latest patch set?

Yes, it does neither apply on Linus tree nor on tip/irq/core branch.

Thanks,

	tglx
