Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556Ab1D2C24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 22:28:56 -0400
Received: from kroah.org ([198.145.64.141]:35948 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758382Ab1D2C2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 22:28:44 -0400
Date: Thu, 28 Apr 2011 19:19:35 -0700
From: Greg KH <greg@kroah.com>
To: Xianghua Xiao <xiaoxianghua@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: PCIe/PCI rescan for new FPGA devices
Message-ID: <20110429021935.GA22370@kroah.com>
References: <BANLkTikFGJheY3XmdA7h8gFNvvHTjZjJnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikFGJheY3XmdA7h8gFNvvHTjZjJnQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 06:06:50PM -0500, Xianghua Xiao wrote:
> I have a FPGA-PCIe device and a FPGA-PCI device that are empty at
> kernel boot time, they're only loaded after kernel is up. After I load
> FPGA images, "lspci" can not show the device, "echo 1 >
> /sys/bus/pci/rescan" also does nothing about it. With a reboot I can
> see the devices are allocated correctly though, but I want to avoid
> the reboot.
> 
> I checked at fakephp(which is to be deprecated) and hotplug/rescan,
> none of that worked for this scenario.
> 
> Can 'rescan' handle cases like this? or, is there a way that I tell
> the kernel to reserve a few BARs somehow in the PCI topology at
> bootime so I can "insert" the FPGAs later?

Your firmware has to do this, see the PCI hotplug specification for
details as to the proper procedure for this.

Best of luck,

greg k-h
