Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab2GXJuD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 05:50:03 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42483 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751074Ab2GXJuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 05:50:00 -0400
Date: Tue, 24 Jul 2012 10:49:10 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Cyril Chemparathy <cyril@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nico@linaro.org" <nico@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [RFC 23/23] ARM: keystone: add switch over to high physical
 address range
Message-ID: <20120724094910.GC20132@arm.com>
References: <1343092165-9470-1-git-send-email-cyril@ti.com>
 <1343092165-9470-24-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343092165-9470-24-git-send-email-cyril@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 02:09:25AM +0100, Cyril Chemparathy wrote:
> Keystone platforms have their physical memory mapped at an address outside the
> 32-bit physical range.  A Keystone machine with 16G of RAM would find its
> memory at 0x0800000000 - 0x0bffffffff.

Ah, so the patches start to make sense now :). The PHYS_OFFSET is at
32G. I'll go back and look at the patches.

-- 
Catalin
