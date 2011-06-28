Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab1F1XY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 19:24:29 -0400
Received: from relais.videotron.ca ([24.201.245.36]:9386 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab1F1XYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 19:24:23 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 28 Jun 2011 19:24:22 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>, Rob Herring <rob.herring@calxeda.com>
Subject: Re: [RFC PATCH 0/4] ARM: make mach/hardware.h optional
In-reply-to: <1309301859-17651-1-git-send-email-robherring2@gmail.com>
Message-id: <alpine.LFD.2.00.1106281919310.2142@xanadu.home>
References: <1309301859-17651-1-git-send-email-robherring2@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jun 2011, Rob Herring wrote:

> From: Rob Herring <rob.herring@calxeda.com>
> 
> Currently, all ARM platforms must have a mach/hardware.h include. This is
> because it is ultimately included by linux/pci.h which is included in many
> places even for !CONFIG_PCI.
> 
> This could be fixed simply with an ifdef around the include of mach/hardware.h
> in asm/pci.h. However, in the interest of fixing this for single kernel
> binary builds, this series removes the include of mach/hardware.h outside of
> mach-* and plat-*. What's used from hardware.h is a couple of PCI defines. 
> Converting them to variables allows each platform to set the values as needed.

Excellent !  This is certainly moving things in the right direction.

For the 4 patches, you can add:

Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>

Obviously for patch 1/4 it would be nice to have the opinion of the PCI 
maintainer as well.


Nicolas
