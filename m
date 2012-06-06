Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431Ab2FFVCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:02:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:51952 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758277Ab2FFVCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:02:03 -0400
Date: Wed, 6 Jun 2012 23:01:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Iyer, Sundar" <sundar.iyer@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "Monroy, German" <german.monroy@intel.com>
Subject: RE: [PATCH v2] x86/irq: handle chained interrupts during IRQ
 migration
In-Reply-To: <2FABAEF0D3DCAF4F9C9628D6E2F968451D8329@BGSMSX102.gar.corp.intel.com>
Message-ID: <alpine.LFD.2.02.1206062301330.3086@ionos>
References: <1338370137-18929-1-git-send-email-sundar.iyer@intel.com> <2FABAEF0D3DCAF4F9C9628D6E2F968451D8329@BGSMSX102.gar.corp.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2012, Iyer, Sundar wrote:
> 
> Any comments on this version? Or do you suggest to add a new flag in
> the accessors and set it?

That's what I said IIRC.
