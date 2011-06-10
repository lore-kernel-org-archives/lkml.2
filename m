Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab1FJQLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 12:11:47 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27706 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1FJQLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 12:11:45 -0400
Date: Fri, 10 Jun 2011 09:11:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Toralf =?UTF-8?B?RsO2cnN0ZXI=?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: non-printable characters in /proc/interrupts
Message-Id: <20110610091132.90531e0e.randy.dunlap@oracle.com>
In-Reply-To: <201106101040.20282.toralf.foerster@gmx.de>
References: <201106101040.20282.toralf.foerster@gmx.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090205.4DF2423F.0068:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jun 2011 10:40:19 +0200 Toralf Förster wrote:

> I've wondering about this entry at my ThinkPad T400 (kernel 2.6.39.1):
> 
> n22 ~ # grep 47: /proc/interrupts
>  47:      44041      69740   PCI-MSI-edge      l▒��@�E�
> 
> I attached the output of 
> $>grep 47: /proc/interrupts > /tmp/int47
> onto this email, the complete table looks like this :
> 
> n22 ~ # cat /proc/interrupts
>            CPU0       CPU1       
>   0:     605293      71393   IO-APIC-edge      timer
>   1:      13432          4   IO-APIC-edge      i8042
>   8:         55         64   IO-APIC-edge      rtc0
>   9:       6248        509   IO-APIC-fasteoi   acpi
>  12:       1389         72   IO-APIC-edge      i8042
>  16:          0          0   IO-APIC-fasteoi   uhci_hcd:usb6
>  17:          0          0   IO-APIC-fasteoi   uhci_hcd:usb7
>  18:          0          0   IO-APIC-fasteoi   uhci_hcd:usb8
>  19:          0          0   IO-APIC-fasteoi   ehci_hcd:usb2
>  20:      52881          0   IO-APIC-fasteoi   uhci_hcd:usb3
>  21:        329         37   IO-APIC-fasteoi   uhci_hcd:usb4
>  22:          0          0   IO-APIC-fasteoi   uhci_hcd:usb5
>  23:      30046       8743   IO-APIC-fasteoi   ehci_hcd:usb1
>  40:          0          0   PCI-MSI-edge      PCIe PME
>  41:          0          0   PCI-MSI-edge      PCIe PME
>  42:          0          0   PCI-MSI-edge      PCIe PME
>  43:          0          0   PCI-MSI-edge      PCIe PME
>  44:     484163      55698   PCI-MSI-edge      ahci
>  45:        750       1809   PCI-MSI-edge      eth0
>  46:         94        213   PCI-MSI-edge      hda_intel
>  47:      44399      70713   PCI-MSI-edge      l▒��@�E�
>  48:      71969     102457   PCI-MSI-edge      iwlagn
> NMI:          0          0   Non-maskable interrupts
> LOC:   10167789   10321319   Local timer interrupts
> SPU:          0          0   Spurious interrupts
> PMI:          0          0   Performance monitoring interrupts
> IWI:        213        200   IRQ work interrupts
> RES:     289390     333102   Rescheduling interrupts
> CAL:       4677       4542   Function call interrupts
> TLB:      22261      16007   TLB shootdowns
> TRM:          0          0   Thermal event interrupts
> THR:          0          0   Threshold APIC interrupts
> MCE:          0          0   Machine check exceptions
> MCP:         41         41   Machine check polls
> ERR:          0
> MIS:          0

Is there any other info (like dmesg or boot log) that tells what
device/driver uses interrupt 47 ?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
