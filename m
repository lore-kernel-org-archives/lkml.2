Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab1K3RSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 12:18:42 -0500
Received: from bay0-omc2-s21.bay0.hotmail.com ([65.54.190.96]:23190 "EHLO
	bay0-omc2-s21.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755565Ab1K3RSk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 12:18:40 -0500
Message-ID: <BAY163-W80F10350D24162EFC3699FBB00@phx.gbl>
X-Originating-IP: [82.43.252.147]
From: Anand Kanaginhal <anand_dk@hotmail.com>
To: <mjg59@srcf.ucam.org>, <greg@kroah.com>
CC: Linux PCI mailing <linux-pci@vger.kernel.org>,
        linux kernel mailing <linux-kernel@vger.kernel.org>,
        linux hotplug mailing <linux-hotplug@vger.kernel.org>
Subject: RE: PCIe Hotplugging not working
Date: Wed, 30 Nov 2011 09:18:39 -0800
Importance: Normal
In-Reply-To: <20111130154022.GA1411@srcf.ucam.org>
References: <BAY163-W52E309F419E3588206D889FBB30@phx.gbl>,<BAY163-W47DD39095DA3EB108AA3F2FBB30@phx.gbl>,<20111130154022.GA1411@srcf.ucam.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 30 Nov 2011 17:18:39.0967 (UTC) FILETIME=[1A5BCEF0:01CCAF84]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Mathew,
I have following options set 

CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_HOTPLUG_PCI_ACPI=m

Hi -Greg,
lspci -k output results indicate the standard hotplug controller module controls this device ? 

03:09.0 PCI bridge: PLX Technology, Inc. PEX 8533 32-lane, 6-port PCI Express Switch (rev aa)
    Kernel driver in use: pcieport
    Kernel modules: shpchp
04:00.0 Memory controller: Device 174a:0701
    Kernel driver in use: pcidrv



Thanks
Anand

----------------------------------------
> Date: Wed, 30 Nov 2011 15:40:22 +0000
> From: mjg59@srcf.ucam.org
> To: anand_dk@hotmail.com
> CC: linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org; linux-hotplug@vger.kernel.org
> Subject: Re: PCIe Hotplugging not working
>
> Make sure that you have CONFIG_HOTPLUG_PCI_ACPI=y and
> CONFIG_HOTPLUG_PCI_PCIE=y.
>
> --
> Matthew Garrett | mjg59@srcf.ucam.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/
 		 	   		  