Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619Ab1EaV1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 17:27:01 -0400
Received: from c-76-21-10-192.hsd1.ca.comcast.net ([76.21.10.192]:58983 "EHLO
	saboo.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932529Ab1EaV07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 17:26:59 -0400
X-Greylist: delayed 764 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 May 2011 17:26:59 EDT
Message-ID: <4DE55A26.6040702@goop.org>
Date: Tue, 31 May 2011 14:14:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: NetDev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 3.0-rc1: DMAR errors from iwlagn
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a Lenovo X220 with:

03:00.0 Network controller: Intel Corporation Centrino Ultimate-N 6300 (rev 35)
	Subsystem: Intel Corporation Centrino Ultimate-N 6300 3x3 AGN
	Flags: bus master, fast devsel, latency 0, IRQ 50
	Memory at d2500000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: <access denied>
	Kernel driver in use: iwlagn
	Kernel modules: iwlagn

With 3.0-rc1, I'm seeing these in dmesg:

DRHD: handling fault status reg 2
DMAR:[DMA Write] Request device [03:00.0] fault addr ffe8a000 
DMAR:[fault reason 05] PTE Write access is not set
DRHD: handling fault status reg 2
DMAR:[DMA Write] Request device [03:00.0] fault addr ffd5a000 
DMAR:[fault reason 05] PTE Write access is not set
DRHD: handling fault status reg 2
DMAR:[DMA Write] Request device [03:00.0] fault addr ffd52000 
DMAR:[fault reason 05] PTE Write access is not set

but the device seems to be working OK.

Thanks,
	J

