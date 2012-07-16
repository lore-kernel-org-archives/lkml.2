Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab2GPIWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 04:22:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:51976 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab2GPIW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 04:22:27 -0400
Date: Mon, 16 Jul 2012 10:22:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gong <gong.chen@linux.intel.com>
cc: tony.luck@intel.com, borislav.petkov@amd.com, peterz@infradead.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] tmp patch to fix hotplug issue in CMCI storm
In-Reply-To: <50038790.6040707@linux.intel.com>
Message-ID: <alpine.LFD.2.02.1207161021130.32033@ionos>
References: <alpine.LFD.2.02.1206181422420.3086@ionos> <1340086140-13652-1-git-send-email-gong.chen@linux.intel.com> <4FF3FAF9.4060302@linux.intel.com> <50038790.6040707@linux.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2012, Chen Gong wrote:
> 
> Are you still care about this thread any more? Any plan to update it?
> Hope to get your feedback ASAP.

Can you please collect the latest series and send it to lkml, Tony and
Boris. I think it's ok as is now.

Thanks,

	tglx
