Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161137Ab2GLOC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 10:02:59 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:49104 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161027Ab2GLOC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 10:02:57 -0400
Message-ID: <4FFED900.1020606@xs4all.nl>
Date: Thu, 12 Jul 2012 16:02:40 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: Jan Ceuleers <jan.ceuleers@computer.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Clemens Ladisch <clemens@ladisch.de>,
        Simon Jones <sijones2010@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 3.4.4: disabling irq
References: <Pine.LNX.4.44L0.1207111114460.1559-100000@iolanthe.rowland.org> <4FFECFC5.2080803@xs4all.nl> <4FFED46F.1080600@computer.org>
In-Reply-To: <4FFED46F.1080600@computer.org>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-12 15:43, Jan Ceuleers wrote:
> On 07/12/2012 03:23 PM, Udo van den Heuvel wrote:
>> How to list what modules/programs are using that irq?
> 
> cat /proc/interrupts

# cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3
  0:         40          0          0          0   IO-APIC-edge      timer
  1:          1          4      91884        418   IO-APIC-edge      i8042
  4:          1         25     607223       1584   IO-APIC-edge      serial
  6:          0          0          8          0   IO-APIC-edge      floppy
  7:          1          0          0          0   IO-APIC-edge
parport0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 12:          3        106     980333       3914   IO-APIC-edge      i8042
 14:          0          5     169732        457   IO-APIC-edge
pata_atiixp
 15:          0          0          0          0   IO-APIC-edge
pata_atiixp
 16:          0          0       3038         33   IO-APIC-fasteoi
sata_sil24, ohci_hcd:usb1, ohci_hcd:usb2, snd_hda_intel
 17:          0          4      24053        119   IO-APIC-fasteoi
ehci_hcd:usb3
 18:         25        190   18052161      21311   IO-APIC-fasteoi
ohci_hcd:usb5, ohci_hcd:usb6, ohci_hcd:usb7
 19:          1          9     187895        487   IO-APIC-fasteoi
ehci_hcd:usb4
 20:          7        135    3756346       8907   IO-APIC-fasteoi   serial
 22:        127        719   14673690      33318   IO-APIC-fasteoi   ahci
 43:        115       1072   33699508      73116   PCI-MSI-edge      eth0
 44:         27        252    3044666      11507   PCI-MSI-edge      radeon
 45:          0          0         21          0   PCI-MSI-edge
snd_hda_intel
NMI:          0          0          0          0   Non-maskable interrupts
LOC:   15971203   15548951   13031603   13145359   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:          0          0          0          0   Performance
monitoring interrupts
IWI:          0          0          0          0   IRQ work interrupts
RTR:          0          0          0          0   APIC ICR read retries
RES:   57916374   44634814   19199377   43219640   Rescheduling interrupts
CAL:       2241       2293       2327       2196   Function call interrupts
TLB:     577983     648537     579293     635466   TLB shootdowns
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:        581        581        581        581   Machine check polls
ERR:          0
MIS:          0



So what can we conclude?

Kind regards,
Udo
