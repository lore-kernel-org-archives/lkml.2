Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab1LIHZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 02:25:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55885 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965Ab1LIHZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 02:25:37 -0500
Date: Fri, 9 Dec 2011 08:23:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: andi.kleen@intel.com, linux-kernel@vger.kernel.org,
        Chen Gong <gong.chen@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH-RESEND] x86: add IRQ context simulation in module
 mce-inject
Message-ID: <20111209072354.GH24537@elte.hu>
References: <4ec2fc2492784d824@agluck-desktop.sc.intel.com>
 <4edfa0a13094144086@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4edfa0a13094144086@agluck-desktop.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luck, Tony <tony.luck@intel.com> wrote:

> mce-inject provides a mechanism to simulate errors so that test
> scripts can check for correct operation of the kernel without
> requiring any specialized hardware to create rare events.
> 
> The existing code can simulate events in normal process context
> and also in NMI context - but not in IRQ context. This patch
> fills that gap.
> 
> Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
> Acked-by: Tony Luck <tony.luck@intel.com>

Looks good to me. Will show up in the RAS tree i guess?

Thanks,

	Ingo
