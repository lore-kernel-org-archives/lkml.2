Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab2JVGiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 02:38:01 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:54290 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab2JVGiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 02:38:00 -0400
Subject: Re: Major performance regressions in 3.7rc1/2
From: Jimster480 <jimster480@gmail.com>
Reply-To: jimster480@gmail.com
To: Patrik Kullman <patrik.kullman@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <CAGPN=9Qx1JAr6CGO-JfoR2ksTJG_CLLZY_oBA_TFMzA_OSfiFg@mail.gmail.com>
References: <CAGPN=9Qx1JAr6CGO-JfoR2ksTJG_CLLZY_oBA_TFMzA_OSfiFg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: 0v1
Date: Mon, 22 Oct 2012 02:37:57 -0400
Message-ID: <1350887877.3673.2.camel@jimster480-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well have you tried building the kernel yourself? It might be the
options that they are using in the kernel, since the Ubuntu team builds
the kernel with almost everything on, including debugging and sometimes
experimental features. 
You could copy your current conf and then take a look at it. 
On Mon, 2012-10-22 at 08:03 +0200, Patrik Kullman wrote:
> Hi,
> 
> I'm using an Asus Zenbook UX31E and have been installing all RCs in
> hope of improving the Wireless and Touchpad functionality.
> However, when trying 3.7 (rc1 and now rc2) I have major performance issues.
> 
> Easiest way to reproduce is to launch and play a game like Nexuiz,
> where the computer will lag, stutter and freeze until the machine is
> unresponsive within a couple of minutes.
> But an easy workload like browsing will also cause lags when switching
> tabs or redrawing a web page after a tab switch.
> Basically 3.7 is unusable for this machine.
> 
> I have been installing the pre-built kernels from
> http://kernel.ubuntu.com/~kernel-ppa/mainline/
> 
> In case lspci is interesting:
> 00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor
> Family DRAM Controller (rev 09)
> 00:02.0 VGA compatible controller: Intel Corporation 2nd Generation
> Core Processor Family Integrated Graphics Controller (rev 09)
> 00:16.0 Communication controller: Intel Corporation 6 Series/C200
> Series Chipset Family MEI Controller #1 (rev 04)
> 00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset
> Family High Definition Audio Controller (rev 05)
> 00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
> Family PCI Express Root Port 1 (rev b5)
> 00:1c.1 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
> Family PCI Express Root Port 2 (rev b5)
> 00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
> Family PCI Express Root Port 4 (rev b5)
> 00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset
> Family USB Enhanced Host Controller #1 (rev 05)
> 00:1f.0 ISA bridge: Intel Corporation QS67 Express Chipset Family LPC
> Controller (rev 05)
> 00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series
> Chipset Family 6 port SATA AHCI Controller (rev 05)
> 00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family
> SMBus Controller (rev 05)
> 02:00.0 Network controller: Atheros Communications Inc. AR9485
> Wireless Network Adapter (rev 01)
> 03:00.0 USB controller: Fresco Logic Device 1009 (rev 02)
> 
> 
> Let me know if there are some simple tests I can do, I'm not sure I'll
> have time to bisect any time soon.
> 
> Thanks in advance,
> Patrik
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


