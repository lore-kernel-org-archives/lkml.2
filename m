Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab2ECNAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 09:00:32 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46516 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751236Ab2ECNAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 09:00:31 -0400
Date: Thu, 3 May 2012 13:59:55 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yilu Mao <ylmao@marvell.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Baohua.Song@csr.com" <Baohua.Song@csr.com>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5] ARM: cache-l2x0.c: save the final aux ctrl value
 for resuming
Message-ID: <20120503125955.GE27872@arm.com>
References: <1336046857-24133-1-git-send-email-ylmao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336046857-24133-1-git-send-email-ylmao@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 01:07:37PM +0100, Yilu Mao wrote:
> There is a bug if l2x0 controller has been enabled when calling
> l2x0_init, the aux ctrl register will not be saved in l2x0_saved_regs.
> Therefore we will use uninitialized l2x0_saved_regs.aux_ctrl for
> resuming later.
> 
> In this patch, the aux ctrl value is read and saved after it is
> initialized. So we have the real value being set for resuming.
> 
> Signed-off-by: Yilu Mao <ylmao@marvell.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
