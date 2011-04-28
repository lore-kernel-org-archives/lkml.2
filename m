Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562Ab1D1XGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 19:06:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57722 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab1D1XGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 19:06:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=xYKlFDn4EipSPlYAq9mNrXEShiRXRXrsRBWe1lr3J20n6oktLLRxOp3wjtEDHRiM36
         xaiqBAZc2PM8N8ULhtiw/0wOPBjKJ/zVpEQKGJBvpYUXUsJzpkBilUT5jP7G1Zg4llFi
         T4HGN0GzxFRZ8aPPjwcF/2qtqnZkjl9XuHkNI=
MIME-Version: 1.0
Date: Thu, 28 Apr 2011 18:06:50 -0500
Message-ID: <BANLkTikFGJheY3XmdA7h8gFNvvHTjZjJnQ@mail.gmail.com>
Subject: PCIe/PCI rescan for new FPGA devices
From: Xianghua Xiao <xiaoxianghua@gmail.com>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a FPGA-PCIe device and a FPGA-PCI device that are empty at
kernel boot time, they're only loaded after kernel is up. After I load
FPGA images, "lspci" can not show the device, "echo 1 >
/sys/bus/pci/rescan" also does nothing about it. With a reboot I can
see the devices are allocated correctly though, but I want to avoid
the reboot.

I checked at fakephp(which is to be deprecated) and hotplug/rescan,
none of that worked for this scenario.

Can 'rescan' handle cases like this? or, is there a way that I tell
the kernel to reserve a few BARs somehow in the PCI topology at
bootime so I can "insert" the FPGAs later?

Thanks,
Xianghua
