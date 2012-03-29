Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783Ab2C2KUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 06:20:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:51157 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529Ab2C2KUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 06:20:05 -0400
Date: Thu, 29 Mar 2012 12:19:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yanmin Zhang <yanmin_zhang@linux.intel.com>
cc: "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, hpa@zytor.com
Subject: Re: [PATCH] x86_fixup_irqs: Fix possible missing interrupt handle
 when disabling CPU
In-Reply-To: <1332913133.1916.271.camel@ymzhang>
Message-ID: <alpine.LFD.2.02.1203291219200.2542@ionos>
References: <27240C0AC20F114CBF8149A2696CBE4A05DFB3@SHSMSX101.ccr.corp.intel.com> <1332913133.1916.271.camel@ymzhang>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2012, Yanmin Zhang wrote:
> On Mon, 2012-03-26 at 07:11 +0000, Liu, Chuansheng wrote:
> Hope my explanation could be a little clearer.

Yeah. I fixed up the changelog already.

Thanks,

	tglx
