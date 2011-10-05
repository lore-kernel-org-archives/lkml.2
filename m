Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935213Ab1JETZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 15:25:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:34408 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934402Ab1JETZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 15:25:21 -0400
Date: Wed, 5 Oct 2011 21:25:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fenghua Yu <fenghua.yu@intel.com>
cc: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <lenb@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/8] kernel/cpu.c: Define bsp_hotpluggable variable
In-Reply-To: <1317832759-10223-9-git-send-email-fenghua.yu@intel.com>
Message-ID: <alpine.LFD.2.02.1110052122240.18778@ionos>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com> <1317832759-10223-9-git-send-email-fenghua.yu@intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Oct 2011, Fenghua Yu wrote:

> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> This gloable variable controls BSP (aka CPU0) hotplug. If set, BSP is
> hotpluggable. By default, it's 0. On X86, kernel option bsp_hotpluggable sets
> the variable as 1.

.... and on !x86 its just pointless.
 
I have yet to see a justification for that whole cpu0 unplugging
business.

If there is a real reason that this is desireable, then ALL cpu0
assumptions in arch/x86 need to be cleaned up and fixed.

Thanks,

	tglx


