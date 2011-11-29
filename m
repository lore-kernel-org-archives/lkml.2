Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab1K2L4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 06:56:14 -0500
Received: from bay0-omc4-s16.bay0.hotmail.com ([65.54.190.218]:17024 "EHLO
	bay0-omc4-s16.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752817Ab1K2L4M convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 06:56:12 -0500
Message-ID: <BAY163-W47DD39095DA3EB108AA3F2FBB30@phx.gbl>
X-Originating-IP: [82.43.252.147]
From: Anand Kanaginhal <anand_dk@hotmail.com>
To: Linux PCI mailing <linux-pci@vger.kernel.org>,
        linux kernel mailing <linux-kernel@vger.kernel.org>,
        linux hotplug mailing <linux-hotplug@vger.kernel.org>
Subject: PCIe Hotplugging not working
Date: Tue, 29 Nov 2011 03:56:12 -0800
Importance: Normal
In-Reply-To: <BAY163-W52E309F419E3588206D889FBB30@phx.gbl>
References: <BAY163-W52E309F419E3588206D889FBB30@phx.gbl>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 29 Nov 2011 11:56:12.0462 (UTC) FILETIME=[E3EF14E0:01CCAE8D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



I am trying to get PCIe endpoint hot - plugging working

The Set up is such that there is one endpoint (our custom device) connected to PCI  switch PLX 8609 8 port 8 lane switch. 
1. I have my driver module compiled, copied into /lib/modules/`uname -r`/kernel/drivers/char/
2. I run depmod and "modules.pcimap" also got updated with my module. 

However
 if I unplug and plug in the endpoint, my driver .probe and .remove functions
 are not being invoked. Is there something more to be done at the bus 
level to get the driver to hot plug ?

I have tried various kernel version, Currently I am trying on 2.6.38.12 (UBUNTU flavor).
First is there anything missing ? Also Please give me some pointers and debug direction.

Thanks
Anand

 		 	   		  