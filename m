Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768812Ab2KOTbD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 14:31:03 -0500
Received: from arrakis.dune.hu ([78.24.191.176]:44186 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1768775Ab2KOTbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 14:31:00 -0500
Date: Thu, 15 Nov 2012 20:30:50 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, arnd@arndb.de,
        linux-mips@linux-mips.org
Subject: Re: [RFC PATCH v1 26/31] ARC: Build system: Makefiles, Kconfig,
 Linker script
Message-ID: <20121115193050.GA1244@linux-mips.org>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
 <1352281674-2186-27-git-send-email-vgupta@synopsys.com>
 <50A52B45.6030907@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A52B45.6030907@imgtec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 05:49:57PM +0000, James Hogan wrote:

> On 07/11/12 09:47, Vineet Gupta wrote:
> > +config ARC
> 
> I just came across arch/mips/Kconfig which also defines ARC (and ARC32).
> It's only used within arch/mips/, however it's probably more likely that
> your ARC/CONFIG_ARC will find it's way into the generic bits of the
> kernel which could get hit when the other ARC is defined.
> 
> Perhaps it's worth getting the other ARC renamed just in case?

The MIPS world surely isn't as attached to the CONFIG_ARC config symbol
as Synopsis so I'm going to rename CONFIG_ARC and a few other firmware
related config symbols to use a consistent prefix of CONFIG_FW_.

  Ralf
