Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab2AEBWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 20:22:06 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47014 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab2AEBWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 20:22:03 -0500
Date: Thu, 5 Jan 2012 01:22:00 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        robherring2@gmail.com, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCHv4 2/4] gpio: add a driver for the Synopsys DesignWare APB
 GPIO block
Message-ID: <20120105012200.GA4641@page>
References: <1325517248-32032-1-git-send-email-jamie@jamieiles.com>
 <1325517248-32032-2-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325517248-32032-2-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 02, 2012 at 03:14:06PM +0000, Jamie Iles wrote:
> The Synopsys DesignWare block is used in some ARM devices (picoxcell)
> and can be configured to provide multiple banks of GPIO pins.
> 
> v3:	- depend on rather than select IRQ_DOMAIN
> 	- split IRQ support into a separate patch
> v2:	- use Rob Herring's irqdomain in generic irq chip patches
> 	- use reg property to indicate bank index
> 	- support irqs on both edges based on LinusW's u300 driver
> 
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Linus Walleij <linus.walleij@stericsson.com>
> Acked-by: Rob Herring <rob.herring@calxeda.com>
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>

Hmm, what I have here doesn't play nicely with sparsely populated banks 
e.g. A, C, D.  Fixed series to follow.

Thanks,

Jamie
