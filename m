Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab1BDJku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 04:40:50 -0500
Received: from www.tglx.de ([62.245.132.106]:41040 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096Ab1BDJkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 04:40:49 -0500
Message-ID: <4D4BC98A.1090006@linutronix.de>
Date: Fri, 04 Feb 2011 10:40:26 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Mitch Bradley <wmb@firmworks.com>
CC: Grant Likely <grant.likely@secretlab.ca>, sodaville@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH TIP 03/14] x86/dtb: Add a device tree for CE4100
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de>	<1295843342-1122-4-git-send-email-bigeasy@linutronix.de>	<20110127050027.GB23443@yookeroo>	<20110127091147.GA9770@www.tglx.de> <20110203205928.GH6180@angua.secretlab.ca> <4D4B1EFD.4060305@firmworks.com>
In-Reply-To: <4D4B1EFD.4060305@firmworks.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mitch Bradley wrote:

> The text representation is "D,F" , where D is the hexadecimal ASCII 
> representation of the binary number ddddd and F is the hexadecimal ASCII 
> representation of the binary number fff .  So "show-devs" will display 
> names like  "/pci/ethernet@12,e" - device number 0x12, function number 0xe.

[snip more of it]

> I don't know how this plays out in the flattened DT world, but the above 
> is a summary of what the PCI bus binding stipulates.

Thanks for clearing it up. After David pointed it out I looked it up in
the PCI spec and it seems to match what you saying here.

Sebastian
