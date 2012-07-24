Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab2GXJmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 05:42:21 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42148 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753313Ab2GXJmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 05:42:19 -0400
Date: Tue, 24 Jul 2012 10:41:43 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Cyril Chemparathy <cyril@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nico@linaro.org" <nico@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [RFC 01/23] ARM: LPAE: disable phys-to-virt patching on PAE
 systems
Message-ID: <20120724094143.GB20132@arm.com>
References: <1343092165-9470-1-git-send-email-cyril@ti.com>
 <1343092165-9470-2-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343092165-9470-2-git-send-email-cyril@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 02:09:03AM +0100, Cyril Chemparathy wrote:
> From: Vitaly Andrianov <vitalya@ti.com>
> 
> The current phys-to-virt patching mechanism is broken on PAE machines with
> 64-bit physical addressing.  This patch disables the patching mechanism in
> such configurations.

It may be broken, I don't remember whether I tested this feature. What's
the PHYS_OFFSET on your platform? Is it within the low 4GB range?

-- 
Catalin
