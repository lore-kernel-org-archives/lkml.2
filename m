Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab1KQAJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 19:09:10 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:60004 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750760Ab1KQAJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 19:09:08 -0500
From: Kevin Hilman <khilman@ti.com>
To: Felipe Balbi <balbi@ti.com>, Jean Pihet <jean.pihet@newoldbits.com>
Cc: Tony Lindgren <tony@atomide.com>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH/RESEND #3 0/7] SmartReflex Patches
Organization: Texas Instruments, Inc.
References: <1321346765-16633-1-git-send-email-balbi@ti.com>
Date: Wed, 16 Nov 2011 16:09:03 -0800
In-Reply-To: <1321346765-16633-1-git-send-email-balbi@ti.com> (Felipe Balbi's
	message of "Tue, 15 Nov 2011 10:45:58 +0200")
Message-ID: <87obwb625c.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Jean

Felipe Balbi <balbi@ti.com> writes:

> here's a bunch of patches to smartreflex which have been pending
> for months.

The SmartReflex code is going through a major rework by Jean so it can be
converted into a real driver and moved under drivers/*.

I'll leave it to Jean to incorporate these changes into his rework as he
sees fit, although I've queued the IRQ fix for v3.2-rc.

Kevin
