Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab2HZS0H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 14:26:07 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60880 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754860Ab2HZS0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 14:26:04 -0400
Date: Sun, 26 Aug 2012 20:26:02 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, joro@8bytes.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 14/19] x86, io-apic: Remove !irq_remapped() check from
 __target_IO_APIC_irq()
Message-ID: <20120826182602.GF3690@breakpoint.cc>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
 <1345470965-24410-15-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345470965-24410-15-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 03:56:00PM +0200, Joerg Roedel wrote:
> This function is only called from default_ioapic_set_affinity()
> which is only used when interrupt remapping is disabled. So
> the check will always evaluate as true and can be removed.

Since commit ("x86, io_apic: Introduce set_affinity function pointer") I
believe and this information would helpfull.

Sebastian
