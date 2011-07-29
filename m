Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab1G2MmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 08:42:19 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55776 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617Ab1G2MmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 08:42:18 -0400
Date: Fri, 29 Jul 2011 08:42:15 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] ARM: msm: Remove PLAT_PHYS_OFFSETS from MSM
 targets
In-Reply-To: <20110729103239.GC25640@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1107290841300.12766@xanadu.home>
References: <1311794355-26988-2-git-send-email-sboyd@codeaurora.org> <1311884291-5409-1-git-send-email-davidb@codeaurora.org> <1311884291-5409-2-git-send-email-davidb@codeaurora.org> <20110729103239.GC25640@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jul 2011, Russell King - ARM Linux wrote:

> On Thu, Jul 28, 2011 at 01:18:11PM -0700, David Brown wrote:
> > Now that MSM can boot with the phys offset patching, eliminate the
> > definitions of the phys offsets, and instead select
> > ARM_PATCH_PHYS_VIRT.
> 
> I think it may be better to remove the EXPERIMENTAL status of
> ARM_PATCH_PHYS_VIRT, and make the option default to 'y' now, so that
> we start building all kernels with this enabled.  If people don't
> want it (and know what they're doing) they can disable it manually
> (maybe make the option only appear for EXPERT).

One of my jumbo patch series is doing that.

> Lets see about that after this merge window is over.

Right.


Nicolas
