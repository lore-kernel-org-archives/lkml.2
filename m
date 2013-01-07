Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab3AGRgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 12:36:48 -0500
Received: from srv8.ns-domain-hosting.de ([46.4.100.167]:39115 "EHLO
	srv8.ns-domain-hosting.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab3AGRgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 12:36:47 -0500
X-Greylist: delayed 518 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jan 2013 12:36:47 EST
X-No-Relay: not in my network
Date: Mon, 7 Jan 2013 18:28:06 +0100
From: Cris <christoph@netpole.com.br>
To: linux-kernel@vger.kernel.org
Subject: VME Tsi148
Message-ID: <20130107182806.32d2600c@vesta>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to use the Tsi148 VME-PCI-bridge on a PowerPC-SPE using the
Debian port, but compiling the kernel 3.7.1 myself. Everything seems
to work as expected, except for the messages:

    vme_tsi148 0000:02:0e.0: Can't get assigned pci irq vector 00
    vme_tsi148 0000:02:0e.0: Chip Initialization failed.
    vme_tsi148: probe of 0000:02:0e.0 failed with error -22

As I understand these messages, the IRQ tsi148 is trying to request is
invalid 0. Am I expected to initialize this, say by a kernel parameter
(I wouldn't know which irq is appropriate), or is this a bug in
drivers/vme/bridges/vme_tsi_148.c? Is there something, I can do about it?

Please CC me, as I'm not on this list.

TIA,

-- 
Christoph Simon
christoph@netpole.com.br
