Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab0EPWna (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 18:43:30 -0400
Received: from www.tglx.de ([62.245.132.106]:55134 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754651Ab0EPWn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 18:43:29 -0400
Date: Mon, 17 May 2010 00:43:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Feng Tang <feng.tang@intel.com>
Subject: Re: [PATCH 5/8] x86/platform: add a wallclock_init func to x86_platforms
 ops
In-Reply-To: <1273873281-17489-6-git-send-email-jacob.jun.pan@linux.intel.com>
Message-ID: <alpine.LFD.2.00.1005170042120.3368@localhost.localdomain>
References: <1273873281-17489-1-git-send-email-jacob.jun.pan@linux.intel.com> <1273873281-17489-6-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010, Jacob Pan wrote:

> From: Feng Tang <feng.tang@intel.com>
> 
> Some wall clock devices use MMIO based HW register, this new function will
> give them a chance to do some initialization work before their get/set_time
> service get called.

NAK. This is the very same patch I reviewed in detail a week
ago. Please fix it.

Thanks,

	tglx
