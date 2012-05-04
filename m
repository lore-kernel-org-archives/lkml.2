Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123Ab2EDQQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 12:16:14 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:42761 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751182Ab2EDQQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 12:16:13 -0400
Message-ID: <4FA400C9.7060606@fold.natur.cuni.cz>
Date: Fri, 04 May 2012 18:16:09 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120319 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.2.11: PCI Express card cannot be re-detected withing cca 60sec
 timeframe
References: <4F6A483D.50702@fold.natur.cuni.cz> <CAE9FiQWSw1h772ijZ6YL4EujwjgvZ84bbDx9VbF_cdE63D-41w@mail.gmail.com> <4F8D390F.9050408@fold.natur.cuni.cz> <CAE9FiQU-_BCCS1OKagVuj8YNrut8-6GH2_i86FsfS8UDWQ1pRA@mail.gmail.com> <CAE9FiQUxoHvUWFXv5LLcBT9vVGnQKp1-Tg7M3XPPULWwtX1iUw@mail.gmail.com> <4F8EFFA3.3050705@fold.natur.cuni.cz> <CAE9FiQVcJbPub1O6nwyNsiijHFpHN0jMsGO4MmKugybPL7Wnug@mail.gmail.com> <4F8F243B.70906@fold.natur.cuni.cz> <CAE9FiQXx1NcGY9cHDiM5isx7NyxWN--Exb-4Gfj0arr6vf5ghQ@mail.gmail.com> <4F909CEB.3060407@fold.natur.cuni.cz> <CAE9FiQU7gnKiwazN_2ykbXSkcuDqWMZNt0CHiGvae2L+rTVGug@mail.gmail.com> <CAE9FiQUk8D20mEFPE0ahwfigbEOHpbRp-X0wt4DC+293msw=4Q@mail.gmail.com> <4F91473A.1080007@fold.natur.cuni.cz> <CAE9FiQUQRAfdG1J6XUVcOVkeR00vyqnCrBg1O3S_ByC3dKOUog@mail.gmail.com> <4F919C22.1070608@fold.natur.cuni.cz> <4F919CD5.7070004@fold.natur.cuni.cz> <CAE9FiQV_cRTDTBmQwNLJtT-N=HTAxBiphBLDmKxM-N0JKyoR-w@mail.gmail.com>
In-Reply-To: <CAE9FiQV_cRTDTBmQwNLJtT-N=HTAxBiphBLDmKxM-N0JKyoR-w@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,
  I went to re-test the acpiphp and pcie_aspm=off to be sure I really have to use pciehp.

Yinghai Lu wrote:
> On Fri, Apr 20, 2012 at 10:28 AM, Martin Mokrejs
> <mmokrejs@fold.natur.cuni.cz> wrote:
>>
>>
>> [30595.338466] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 108
>> [30595.338468] pciehp 0000:00:1c.7:pcie04: LinkState change
>> [30595.338471] pciehp 0000:00:1c.7:pcie04: lnk_status = 7011
>> [30595.338483] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
>> [30595.338486] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
>> [30595.338491] pciehp 0000:00:1c.7:pcie04: Surprise Removal
>> [30595.338525] pciehp 0000:00:1c.7:pcie04: check_link_active: lnk_status = 7011
>> [30595.439441] pciehp 0000:00:1c.7:pcie04: pciehp_check_link_status: lnk_status = 7011
>> [30595.439543] pci 0000:11:00.0: [1033:0194] type 00 class 0x0c0330
>> [30595.439597] pci 0000:11:00.0: reg 10: [mem 0x00000000-0x00001fff 64bit]
>> [30595.439840] pci 0000:11:00.0: PME# supported from D0 D3hot
>> [30595.459499] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c00000-0xf6c01fff 64bit]
>> [30595.459542] pcieport 0000:00:1c.7: PCI bridge to [bus 11-16]
>> [30595.459545] pcieport 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
>> [30595.459550] pcieport 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
>> [30595.459554] pcieport 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
>> [30595.459688] xhci_hcd 0000:11:00.0: enabling device (0100 -> 0102)
>> [30595.459894] xhci_hcd 0000:11:00.0: xHCI Host Controller
>> [30595.459900] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 5
>> [30595.460199] xhci_hcd 0000:11:00.0: irq 19, io mem 0xf6c00000
>> [30595.460306] xhci_hcd 0000:11:00.0: irq 54 for MSI/MSI-X
>> [30595.460310] xhci_hcd 0000:11:00.0: irq 55 for MSI/MSI-X
>> [30595.460314] xhci_hcd 0000:11:00.0: irq 56 for MSI/MSI-X
>> [30595.460318] xhci_hcd 0000:11:00.0: irq 57 for MSI/MSI-X
>> [30595.460321] xhci_hcd 0000:11:00.0: irq 58 for MSI/MSI-X
>> [30595.460472] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
>> [30595.460474] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [30595.460475] usb usb5: Product: xHCI Host Controller
>> [30595.460476] usb usb5: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
>> [30595.460477] usb usb5: SerialNumber: 0000:11:00.0
>> [30595.460569] xHCI xhci_add_endpoint called for root hub
>> [30595.460579] xHCI xhci_check_bandwidth called for root hub
>> [30595.460600] hub 5-0:1.0: USB hub found
>> [30595.460611] hub 5-0:1.0: 2 ports detected
>> [30595.460706] xhci_hcd 0000:11:00.0: xHCI Host Controller
>> [30595.460711] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 6
>> [30595.463431] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
>> [30595.463433] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [30595.463434] usb usb6: Product: xHCI Host Controller
>> [30595.463435] usb usb6: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
>> [30595.463437] usb usb6: SerialNumber: 0000:11:00.0
>> [30595.463506] xHCI xhci_add_endpoint called for root hub
>> [30595.463507] xHCI xhci_check_bandwidth called for root hub
>> [30595.463534] hub 6-0:1.0: USB hub found
>> [30595.463547] hub 6-0:1.0: 2 ports detected
> 
> echo 1 > /sys/..../remove
> 
>> [30607.046714] xhci_hcd 0000:11:00.0: remove, state 4
>> [30607.046719] usb usb6: USB disconnect, device number 1
>> [30607.046764] xHCI xhci_drop_endpoint called for root hub
>> [30607.046766] xHCI xhci_check_bandwidth called for root hub
>> [30607.065341] xhci_hcd 0000:11:00.0: USB bus 6 deregistered
>> [30607.065350] xhci_hcd 0000:11:00.0: remove, state 4
>> [30607.065353] usb usb5: USB disconnect, device number 1
>> [30607.065393] xHCI xhci_drop_endpoint called for root hub
>> [30607.065394] xHCI xhci_check_bandwidth called for root hub
>> [30607.065692] xhci_hcd 0000:11:00.0: USB bus 5 deregistered
>> [30607.065764] pci 0000:11:00.0: freeing pci_dev info
> 
> physically remove that express card
> 
>> [30616.630810] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 108
>> [30616.630813] pciehp 0000:00:1c.7:pcie04: LinkState change
>> [30616.630816] pciehp 0000:00:1c.7:pcie04: lnk_status = 5011
>> [30616.630817] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
>> [30616.630820] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
>> [30616.630858] pciehp 0000:00:1c.7:pcie04: Surprise Removal
>> [30616.630888] pciehp 0000:00:1c.7:pcie04: Disabling domain:bus:device=0000:11:00
>> [30616.630891] pciehp 0000:00:1c.7:pcie04: pciehp_unconfigure_device: domain:bus:dev = 0000:11:00
> 
> physical add...
> 
>> [30708.233725] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 108
>> [30708.233727] pciehp 0000:00:1c.7:pcie04: LinkState change
>> [30708.233738] pciehp 0000:00:1c.7:pcie04: lnk_status = 7011
>> [30708.233739] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
>> [30708.233742] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
>> [30708.233781] pciehp 0000:00:1c.7:pcie04: Surprise Removal
>> [30708.233796] pciehp 0000:00:1c.7:pcie04: check_link_active: lnk_status = 7011
>> [30708.338477] pciehp 0000:00:1c.7:pcie04: pciehp_check_link_status: lnk_status = 7011
>> [30708.338581] pci 0000:11:00.0: [1033:0194] type 00 class 0x0c0330
>> [30708.338632] pci 0000:11:00.0: reg 10: [mem 0x00000000-0x00001fff 64bit]
>> [30708.338876] pci 0000:11:00.0: PME# supported from D0 D3hot
>> [30708.358538] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c00000-0xf6c01fff 64bit]
>> [30708.358575] pcieport 0000:00:1c.7: PCI bridge to [bus 11-16]
>> [30708.358588] pcieport 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
>> [30708.358593] pcieport 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
>> [30708.358597] pcieport 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
>> [30708.358737] xhci_hcd 0000:11:00.0: enabling device (0100 -> 0102)
>> [30708.358791] xhci_hcd 0000:11:00.0: xHCI Host Controller
>> [30708.358799] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 5
>> [30708.359090] xhci_hcd 0000:11:00.0: irq 19, io mem 0xf6c00000
>> [30708.359192] xhci_hcd 0000:11:00.0: irq 54 for MSI/MSI-X
>> [30708.359196] xhci_hcd 0000:11:00.0: irq 55 for MSI/MSI-X
>> [30708.359199] xhci_hcd 0000:11:00.0: irq 56 for MSI/MSI-X
>> [30708.359203] xhci_hcd 0000:11:00.0: irq 57 for MSI/MSI-X
>> [30708.359207] xhci_hcd 0000:11:00.0: irq 58 for MSI/MSI-X
>> [30708.359357] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
>> [30708.359359] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [30708.359360] usb usb5: Product: xHCI Host Controller
>> [30708.359361] usb usb5: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
>> [30708.359363] usb usb5: SerialNumber: 0000:11:00.0
>> [30708.359453] xHCI xhci_add_endpoint called for root hub
>> [30708.359456] xHCI xhci_check_bandwidth called for root hub
>> [30708.359496] hub 5-0:1.0: USB hub found
>> [30708.359509] hub 5-0:1.0: 2 ports detected
>> [30708.359571] xhci_hcd 0000:11:00.0: xHCI Host Controller
>> [30708.359574] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 6
>> [30708.362332] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
>> [30708.362335] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [30708.362337] usb usb6: Product: xHCI Host Controller
>> [30708.362338] usb usb6: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
>> [30708.362340] usb usb6: SerialNumber: 0000:11:00.0
>> [30708.362443] xHCI xhci_add_endpoint called for root hub
>> [30708.362445] xHCI xhci_check_bandwidth called for root hub
>> [30708.362472] hub 6-0:1.0: USB hub found
>> [30708.362490] hub 6-0:1.0: 2 ports detected
> 
> echo 1 /sys/.../remove
> 
>> [30716.380693] xhci_hcd 0000:11:00.0: remove, state 4
>> [30716.380699] usb usb6: USB disconnect, device number 1
>> [30716.380752] xHCI xhci_drop_endpoint called for root hub
>> [30716.380754] xHCI xhci_check_bandwidth called for root hub
>> [30716.400795] xhci_hcd 0000:11:00.0: USB bus 6 deregistered
>> [30716.400803] xhci_hcd 0000:11:00.0: remove, state 4
>> [30716.400807] usb usb5: USB disconnect, device number 1
>> [30716.400846] xHCI xhci_drop_endpoint called for root hub
>> [30716.400848] xHCI xhci_check_bandwidth called for root hub
>> [30716.401134] xhci_hcd 0000:11:00.0: USB bus 5 deregistered
>> [30716.401207] pci 0000:11:00.0: freeing pci_dev info
> 
> physically remove
> 
>> [30720.175637] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 108
>> [30720.175639] pciehp 0000:00:1c.7:pcie04: LinkState change
>> [30720.175643] pciehp 0000:00:1c.7:pcie04: lnk_status = 5011
>> [30720.175644] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
>> [30720.175648] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
>> [30720.175687] pciehp 0000:00:1c.7:pcie04: Surprise Removal
>> [30720.175718] pciehp 0000:00:1c.7:pcie04: Disabling domain:bus:device=0000:11:00
>> [30720.175721] pciehp 0000:00:1c.7:pcie04: pciehp_unconfigure_device: domain:bus:dev = 0000:11:00
>>
> 
> So the USB host control driver xhci put that 11:00.0 in strange power state.
> 
> please try to boot the system with pcie_aspm=off
> 
> and don't use echo 1 before physically removing the expresscard.


Here I just want to show that pcie_aspm=off is really interpreted and that acpiphp brings
me nothing?

CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

@@ -153,7 +153,8 @@
 pcpu-alloc: [0] 0 1 2 3   
 Built 1 zonelists in Zone order, mobility grouping on.
 Policy zone: Normal      
-Kernel command line: root=/dev/sda5 pciehp.pciehp_debug=1 console=ttyUSB0,115200n8 console=tty0 log_buf_len=409600 
+Kernel command line: root=/dev/sda5 pciehp.pciehp_debug=1 console=ttyUSB0,115200n8 console=tty0 log_buf_len=409600 pcie_aspm=off
+PCIe ASPM is disabled     
 PID hash table entries: 4096 (order: 3, 32768 bytes)
 xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340  
 Checking aperture...       
@@ -406,8 +407,7 @@
 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]   
 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]   
 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP08._PRT]   
-pci0000:00: Requesting ACPI _OSC control (0x1d)   
-pci0000:00: ACPI _OSC control (0x19) granted   
+pci0000:00: Unable to request _OSC control (_OSC support mask:
 ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5
 ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5
 ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5
@@ -669,39 +669,12 @@
 io scheduler noop registered     
 io scheduler deadline registered     
 io scheduler cfq registered (default)    
-pcieport 0000:00:1c.7: irq 42 for MSI/MSI-X   
 pci_hotplug: PCI Hot Plug PCI Core version: 0.5 
-pciehp 0000:00:1c.7:pcie04: Hotplug Controller:     
-pciehp 0000:00:1c.7:pcie04: Seg/Bus/Dev/Func/IRQ : 0000:00:1c.7 IRQ 42  
-pciehp 0000:00:1c.7:pcie04: Vendor ID : 0x8086   
-pciehp 0000:00:1c.7:pcie04: Device ID : 0x1c1e   
-pciehp 0000:00:1c.7:pcie04: Subsystem ID : 0x04b3   
-pciehp 0000:00:1c.7:pcie04: Subsystem Vendor ID : 0x1028  
-pciehp 0000:00:1c.7:pcie04: PCIe Cap offset : 0x40  
-pciehp 0000:00:1c.7:pcie04: PCI resource [13] : [io 0xc000-0xdfff] 
-pciehp 0000:00:1c.7:pcie04: PCI resource [14] : [mem 0xf6c00000-0xf7cfffff] 
-pciehp 0000:00:1c.7:pcie04: PCI resource [15] : [mem 0xf0000000-0xf10fffff 64bit
-pciehp 0000:00:1c.7:pcie04: Slot Capabilities : 0x003cb260   
-pciehp 0000:00:1c.7:pcie04: Physical Slot Number : 7  
-pciehp 0000:00:1c.7:pcie04: Attention Button : no   
-pciehp 0000:00:1c.7:pcie04: Power Controller : no   
-pciehp 0000:00:1c.7:pcie04: MRL Sensor : no   
-pciehp 0000:00:1c.7:pcie04: Attention Indicator : no   
-pciehp 0000:00:1c.7:pcie04: Power Indicator : no   
-pciehp 0000:00:1c.7:pcie04: Hot-Plug Surprise : yes   
-pciehp 0000:00:1c.7:pcie04: EMI Present : no   
-pciehp 0000:00:1c.7:pcie04: Command Completed : no   
-pciehp 0000:00:1c.7:pcie04: Slot Status : 0x0000   
-pciehp 0000:00:1c.7:pcie04: Slot Control : 0x0000   
-pciehp 0000:00:1c.7:pcie04: Link Active Reporting supported   
-pciehp 0000:00:1c.7:pcie04: HPC vendor_id 8086 device_id 1c1e ss_vid 1028
-pciehp 0000:00:1c.7:pcie04: Registering domain:bus:dev=0000:11:00 sun=7    
-pci_bus 0000:11: dev 00, created physical slot 7 
-pciehp 0000:00:1c.7:pcie04: pciehp_get_power_status: SLOTCTRL 58 value read 28 
-pciehp 0000:00:1c.7:pcie04: service driver pciehp loaded   
 pciehp: pcie_port_service_register = 0     
 pciehp: PCI Express Hot Plug Controller Driver version: 0.4
 acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
+pci_bus 0000:11: dev 00, created physical slot 1 
+acpiphp: Slot [1] registered     
 intel_idle: MWAIT substates: 0x21120     
 intel_idle: v0.4 model 0x2A     
 intel_idle: lapic_timer_reliable_states 0xffffffff      


In other words, when I use pcie_aspm=off and have CONFIG_HOTPLUG_PCI_ACPI=y my acpiphp picks up
but express card does not "work"?

The only way to have it working for me is to avoid pcie_aspm=off altogether and not bother about
CONFIG_HOTPLUG_PCI_ACPI value. What do you recommend me?



CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set


--- 8_no__CONFIG_HOTPLUG_PCI_ACPI.txt   2012-05-04 14:55:58.000000000 +0200
+++ 9_no__CONFIG_HOTPLUG_PCI_ACPI.txt   2012-05-04 14:56:14.000000000 +0200
@@ -1,6 +1,6 @@
 Initializing cgroup subsys cpu     
 Linux version 3.4.0-rc5-default (root@vostro) (gcc version 4.5.3 (Gentoo 4.5.3-r2
-Command line: root=/dev/sda5 pciehp.pciehp_debug=1 console=ttyUSB0,115200n8 console=tty0 log_buf_len=409600  
+Command line: root=/dev/sda5 pciehp.pciehp_debug=1 console=ttyUSB0,115200n8 console=tty0 log_buf_len=409600 pcie_aspm=off 
 BIOS-provided physical RAM map:     
 BIOS-e820: 0000000000000000 - 000000000009d400 (usable)    
 BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)    
@@ -153,7 +153,8 @@
 pcpu-alloc: [0] 0 1 2 3   
 Built 1 zonelists in Zone order, mobility grouping on.
 Policy zone: Normal      
-Kernel command line: root=/dev/sda5 pciehp.pciehp_debug=1 console=ttyUSB0,115200n8 console=tty0 log_buf_len=409600 
+Kernel command line: root=/dev/sda5 pciehp.pciehp_debug=1 console=ttyUSB0,115200n8 console=tty0 log_buf_len=409600 pcie_aspm=off
+PCIe ASPM is disabled     
 PID hash table entries: 4096 (order: 3, 32768 bytes)
 xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340  
 Checking aperture...       
@@ -406,8 +407,7 @@
 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]   
 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]   
 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP08._PRT]   
-pci0000:00: Requesting ACPI _OSC control (0x1d)   
-pci0000:00: ACPI _OSC control (0x19) granted   
+pci0000:00: Unable to request _OSC control (_OSC support mask:
 ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5
 ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5
 ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5
@@ -669,36 +669,7 @@
 io scheduler noop registered     
 io scheduler deadline registered     
 io scheduler cfq registered (default)    
-pcieport 0000:00:1c.7: irq 42 for MSI/MSI-X   
 pci_hotplug: PCI Hot Plug PCI Core version: 0.5 
-pciehp 0000:00:1c.7:pcie04: Hotplug Controller:     
-pciehp 0000:00:1c.7:pcie04: Seg/Bus/Dev/Func/IRQ : 0000:00:1c.7 IRQ 42  
-pciehp 0000:00:1c.7:pcie04: Vendor ID : 0x8086   
-pciehp 0000:00:1c.7:pcie04: Device ID : 0x1c1e   
-pciehp 0000:00:1c.7:pcie04: Subsystem ID : 0x04b3   
-pciehp 0000:00:1c.7:pcie04: Subsystem Vendor ID : 0x1028  
-pciehp 0000:00:1c.7:pcie04: PCIe Cap offset : 0x40  
-pciehp 0000:00:1c.7:pcie04: PCI resource [13] : [io 0xc000-0xdfff] 
-pciehp 0000:00:1c.7:pcie04: PCI resource [14] : [mem 0xf6c00000-0xf7cfffff] 
-pciehp 0000:00:1c.7:pcie04: PCI resource [15] : [mem 0xf0000000-0xf10fffff 64bit
-pciehp 0000:00:1c.7:pcie04: Slot Capabilities : 0x003cb260   
-pciehp 0000:00:1c.7:pcie04: Physical Slot Number : 7  
-pciehp 0000:00:1c.7:pcie04: Attention Button : no   
-pciehp 0000:00:1c.7:pcie04: Power Controller : no   
-pciehp 0000:00:1c.7:pcie04: MRL Sensor : no   
-pciehp 0000:00:1c.7:pcie04: Attention Indicator : no   
-pciehp 0000:00:1c.7:pcie04: Power Indicator : no   
-pciehp 0000:00:1c.7:pcie04: Hot-Plug Surprise : yes   
-pciehp 0000:00:1c.7:pcie04: EMI Present : no   
-pciehp 0000:00:1c.7:pcie04: Command Completed : no   
-pciehp 0000:00:1c.7:pcie04: Slot Status : 0x0000   
-pciehp 0000:00:1c.7:pcie04: Slot Control : 0x0000   
-pciehp 0000:00:1c.7:pcie04: Link Active Reporting supported   
-pciehp 0000:00:1c.7:pcie04: HPC vendor_id 8086 device_id 1c1e ss_vid 1028
-pciehp 0000:00:1c.7:pcie04: Registering domain:bus:dev=0000:11:00 sun=7    
-pci_bus 0000:11: dev 00, created physical slot 7 
-pciehp 0000:00:1c.7:pcie04: pciehp_get_power_status: SLOTCTRL 58 value read 28 
-pciehp 0000:00:1c.7:pcie04: service driver pciehp loaded   
 pciehp: pcie_port_service_register = 0     
 pciehp: PCI Express Hot Plug Controller Driver version: 0.4
 intel_idle: MWAIT substates: 0x21120     


Just to make sure there is no way to use acpiphp on my system. Or could the "Unable to request _OSC control"
thing be fixed somehow?

Thanks,
Martin

