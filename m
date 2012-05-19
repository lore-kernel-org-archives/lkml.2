Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab2ESGIb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 02:08:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34233 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab2ESGI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 02:08:29 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 5/5] MIPS: Octeon: Use device tree to register serial ports.
To: David Daney <ddaney.cavm@gmail.com>, linux-mips@linux-mips.org,
        ralf@linux-mips.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
In-Reply-To: <1335489630-27017-6-git-send-email-ddaney.cavm@gmail.com>
References: <1335489630-27017-1-git-send-email-ddaney.cavm@gmail.com> <1335489630-27017-6-git-send-email-ddaney.cavm@gmail.com>
Date: Sat, 19 May 2012 00:08:27 -0600
Message-Id: <20120519060827.0E8F53E046E@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2012 18:20:30 -0700, David Daney <ddaney.cavm@gmail.com> wrote:
> From: David Daney <david.daney@cavium.com>
> 
> Switch to using the device tree to register serial ports.
> 
> Add all the ports with compatible = "cavium,octeon-3860-uart".  Octeon serial
> ports have their own device type, required port flags, and I/O
> functions, so using of_serial.c is not indicated.
> 
> We need to do this as late_initcall, as the 8250 driver must be
> initialized before we add any ports.  8250 initialization is done at
> device_initcall time.
> 
> The OCTEON_IRQ_UART{0,1,2} symbols are removed as they are now unused
> and interfere with irq_domain used by the device tree code.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>
