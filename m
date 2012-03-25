Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab2CYJFR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 05:05:17 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55872 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785Ab2CYJFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 05:05:15 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 25 Mar 2012 11:05:08 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Matthew Garrett <mjg@redhat.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: PCIe ASPM: new Kconfig prompt without help text
Message-ID: <20120325110508.4167f140@stein>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> $ make oldconfig
>     PCI Express ASPM control (PCIEASPM) [Y/?] y
>       Debug PCI Express ASPM (PCIEASPM_DEBUG) [N/y/?] n
>       Default ASPM policy
>       > 1. BIOS default (PCIEASPM_DEFAULT) (NEW)
>         2. Powersave (PCIEASPM_POWERSAVE) (NEW)
>         3. Performance (PCIEASPM_PERFORMANCE) (NEW)
>       choice[1-3]: ?
> 
> There is no help available for this option.

Choices, choices.  Can we get a little explanation here what option should
be chosen in which environments?
-- 
Stefan Richter
-=====-===-- --== ==--=
http://arcgraph.de/sr/
