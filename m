Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab1KQAGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 19:06:13 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:47156 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753962Ab1KQAGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 19:06:12 -0500
From: Kevin Hilman <khilman@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Tony Lindgren <tony@atomide.com>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH/RESEND #3 6/7] arm: omap: smartreflex: fix IRQ handling bug
Organization: Texas Instruments, Inc.
References: <1321346765-16633-1-git-send-email-balbi@ti.com>
	<1321346765-16633-7-git-send-email-balbi@ti.com>
Date: Wed, 16 Nov 2011 16:06:08 -0800
In-Reply-To: <1321346765-16633-7-git-send-email-balbi@ti.com> (Felipe Balbi's
	message of "Tue, 15 Nov 2011 10:46:04 +0200")
Message-ID: <87r51762a7.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Balbi <balbi@ti.com> writes:

F> fix a bug which has been on this driver since
> it was added by the original commit 984aa6db
> which would never clear IRQSTATUS bits.
>
> Signed-off-by: Felipe Balbi <balbi@ti.com>

Queuing this fix for v3.2-rc (branch: for_3.2/fixes/pm)

Kevin
