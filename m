Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab0HBMh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 08:37:59 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:18700 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752969Ab0HBMh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 08:37:57 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEABNZVkxQycSE/2dsb2JhbACgDXLBAg2FLAQ
Date: Mon, 2 Aug 2010 14:37:55 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: David Daney <ddaney@caviumnetworks.com>, ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Marc Zyngier <maz@misterjones.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] watchdog: Add watchdog driver for OCTEON SOCs (v2).
Message-ID: <20100802123755.GV30740@infomag.iguana.be>
References: <20100724035826.GA27516@merkur.ravnborg.org> <1279991765-23962-1-git-send-email-ddaney@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279991765-23962-1-git-send-email-ddaney@caviumnetworks.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David, Ralf,

> The OCTEON is a MIPS64 based SOC family with an on chip watchdog unit.
> 
> The driver is split into two source files one for the C code and one
> for assembly.  Assembly is needed to handle the NMI and then print the
> machine state before the reboot is triggered.
> 
> v2: Stylistic changes suggested by Sam Ravnborg.

This v2 looks good. only small remark is:
> +static struct notifier_block octeon_wdt_cpu_notifier = {
> +	.notifier_call = octeon_wdt_cpu_callback
> +};

Add a comma after octeon_wdt_cpu_callback.

> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
> Cc: Wim Van Sebroeck <wim@iguana.be>

Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Marc Zyngier <maz@misterjones.org>
> Cc: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: Sam Ravnborg <sam@ravnborg.org>

Kind regards,
Wim.

