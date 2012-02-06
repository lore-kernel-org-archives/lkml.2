Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab2BFQSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:18:24 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34715 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab2BFQRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:17:25 -0500
Date: Mon, 6 Feb 2012 16:16:56 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
Cc: Vinod Koul <vinod.koul@intel.com>, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Subject: Re: [PATCH 01/11] dmaengine: add context parameter toprep_slave_sg
	and prep_dma_cyclic
Message-ID: <20120206161655.GB20852@flint.arm.linux.org.uk>
References: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com> <1328218341-31436-2-git-send-email-alexandre.bounine@idt.com> <20120202214350.GB4432@flint.arm.linux.org.uk> <0CE8B6BE3C4AD74AB97D9D29BD24E55202872683@CORPEXCH1.na.ads.idt.com> <1328529182.26182.92.camel@vkoul-udesk3> <0CE8B6BE3C4AD74AB97D9D29BD24E552028729F9@CORPEXCH1.na.ads.idt.com> <1328542134.26182.111.camel@vkoul-udesk3> <0CE8B6BE3C4AD74AB97D9D29BD24E55202872A3B@CORPEXCH1.na.ads.idt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E55202872A3B@CORPEXCH1.na.ads.idt.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 07:56:57AM -0800, Bounine, Alexandre wrote:
> At least corresponding inline functions may use specific data types
> or hide the new parameter like in Russell's code example. (I believe
> he forgot to pass NULL in chan->device->device_prep_slave_sg() as
> the new param there).

No I didn't - I gave a step by step approach.  Step one is to intrduce
the wrapper with no API changes at all fixing up everyone to use the
wrapper.

Step two is where the call in struct dma_device changes.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
