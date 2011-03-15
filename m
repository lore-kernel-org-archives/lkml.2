Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab1COXJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 19:09:53 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50186 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab1COXJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 19:09:51 -0400
Date: Tue, 15 Mar 2011 17:09:43 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/platform changes for v2.6.39
Message-ID: <20110315230943.GA8464@angua.secretlab.ca>
References: <20110315213223.GA21481@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110315213223.GA21481@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 10:32:23PM +0100, Ingo Molnar wrote:
> Linus,
> 
> Please pull the latest x86-platform-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-platform-for-linus
> 
> 
> out-of-topic modifications in x86-platform-for-linus:
> -----------------------------------------------------

... all merged in from my devicetree/next branch which Thomas and I
discussed before hand.  I agree with this pull.

g.

> arch/microblaze/include/asm/pci-bridge.h# 04bea68: of/pci: move of_irq_map_pci() int
> arch/microblaze/include/asm/prom.h # 04bea68: of/pci: move of_irq_map_pci() int
> arch/microblaze/kernel/prom_parse.c# 04bea68: of/pci: move of_irq_map_pci() int
> arch/microblaze/pci/pci-common.c   # 04bea68: of/pci: move of_irq_map_pci() int
> arch/powerpc/include/asm/pci-bridge.h# 04bea68: of/pci: move of_irq_map_pci() int
> arch/powerpc/include/asm/prom.h    # 04bea68: of/pci: move of_irq_map_pci() int
> arch/powerpc/kernel/pci-common.c   # 04bea68: of/pci: move of_irq_map_pci() int
> arch/powerpc/kernel/prom_parse.c   # 04bea68: of/pci: move of_irq_map_pci() int
> drivers/i2c/busses/i2c-ocores.c    # c9e358d: driver-core: remove conditionals 
> drivers/i2c/i2c-core.c             # c9e358d: driver-core: remove conditionals 
> drivers/mmc/host/mmc_spi.c         # c9e358d: driver-core: remove conditionals 
> drivers/net/ethoc.c                # c9e358d: driver-core: remove conditionals 
> drivers/of/Kconfig                 # 96e0a07: x86: dtb: Add support for PCI dev
>                                    # 04bea68: of/pci: move of_irq_map_pci() int
> drivers/of/Makefile                # 04bea68: of/pci: move of_irq_map_pci() int
> drivers/of/of_pci.c                # 96e0a07: x86: dtb: Add support for PCI dev
>                                    # 04bea68: of/pci: move of_irq_map_pci() int
> drivers/rtc/rtc-cmos.c             # 3bcbaf6: rtc: cmos: Add OF bindings
> drivers/rtc/rtc-mrst.c             # 168202c: mrst/vrtc: Avoid using cmos rtc o
> drivers/spi/pxa2xx_spi.c           # c9e358d: driver-core: remove conditionals 
> drivers/spi/pxa2xx_spi_pci.c       # c9e358d: driver-core: remove conditionals 
> drivers/spi/xilinx_spi.c           # c9e358d: driver-core: remove conditionals 
> include/linux/device.h             # c9e358d: driver-core: remove conditionals 
> include/linux/i2c.h                # c9e358d: driver-core: remove conditionals 
> include/linux/of.h                 # 3bcbaf6: rtc: cmos: Add OF bindings
>                                    # c9e358d: driver-core: remove conditionals 
> include/linux/of_pci.h             # 04bea68: of/pci: move of_irq_map_pci() int
> 
>  Thanks,
> 
> 	Ingo
> 
> ------------------>
> Feng Tang (2):
>       x86/platform: Add a wallclock_init func to x86_init.timers ops
>       mrst/vrtc: Avoid using cmos rtc ops
> 
> Grant Likely (1):
>       driver-core: remove conditionals around devicetree pointers
> 
> Henrik Kretzschmar (7):
>       x86: Move ioapic_irq_destination_types to apicdef.h
>       x86: Add dummy mp_save_irq()
>       x86: Rework arch_disable_smp_support() for x86
>       x86: Add dummy functions for compiling without IOAPIC
>       x86: Fix deps of X86_UP_IOAPIC
>       x86: Remove superflous goal definition of tsc_sync
>       x86: Clean up apic.c and apic.h
> 
> Sebastian Andrzej Siewior (15):
>       of/pci: move of_irq_map_pci() into generic code
>       x86/pci: Remove unused variable
>       x86: e820: Remove conditional early mapping in parse_e820_ext
>       x86: Add device tree support
>       x86: dtb: Add a device tree for CE4100
>       x86: dtb: Add irq domain abstraction
>       x86: dtb: Add early parsing of IO_APIC
>       x86: dtb: Add device tree support for HPET
>       x86: dtb: Add support for PCI devices backed by dtb nodes
>       x86: dtb: Add generic bus probe
>       x86: ioapic: Add OF bindings for IO_APIC
>       x86: ce4100: Use OF to setup devices
>       rtc: cmos: Add OF bindings
>       x86: dt: Fix OLPC=y/INTEL_CE=n build
>       x86: dt: Correct local apic documentation in device tree bindings
> 
> Thomas Gleixner (17):
>       x86: OLPC: Remove redundant !X64_64 config dependency
>       x86: OLPC: Hide OLPC_OPENFIRMWARE config switch
>       x86: OLPC: Cleanup config maze completely
>       x86: OLPC: Remove extra OLPC_OPENFIRMWARE_DT indirection
>       x86: OLPC: Make OLPC=n build again
>       x86: ioapic: Remove silly debug bloat in setup_IOAPIC_irqs()
>       x86: ioapic: Split out the nested loop in setup_IO_APIC_irqs()
>       x86: ioapic: Add io_apic_setup_irq_pin()
>       x86: ioapic: Use new setup function in pre_init_apic_IRQ0()
>       x86: ioapic: Use setup function in __io_apic_set_pci_routing()
>       x86: ioapic: Use setup function in __io_apic_setup_irqs()
>       x86: ioapic: Use setup function in setup_IO_APIC_irq_extra()
>       x86: ioapic: Make a few functions static
>       x86: ioapic: Remove useless inlines
>       x86: ioapic: Implement and use io_apic_setup_irq_pin_once()
>       x86: ioapic: Move trigger defines to io_apic.h
>       x86: dt: Cleanup local apic setup
> 
> jacob.jun.pan@linux.intel.com (1):
>       x86: mrst: Remove apb timer read workaround
> 
> 
>  .../devicetree/bindings/i2c/ce4100-i2c.txt         |   93 ++++
>  Documentation/devicetree/bindings/rtc/rtc-cmos.txt |   28 ++
>  Documentation/devicetree/bindings/x86/ce4100.txt   |   38 ++
>  .../devicetree/bindings/x86/interrupt.txt          |   26 ++
>  Documentation/devicetree/bindings/x86/timer.txt    |    6 +
>  Documentation/devicetree/booting-without-of.txt    |   20 +
>  arch/microblaze/include/asm/pci-bridge.h           |   12 +
>  arch/microblaze/include/asm/prom.h                 |   15 -
>  arch/microblaze/kernel/prom_parse.c                |   77 ----
>  arch/microblaze/pci/pci-common.c                   |    1 +
>  arch/powerpc/include/asm/pci-bridge.h              |   10 +
>  arch/powerpc/include/asm/prom.h                    |   15 -
>  arch/powerpc/kernel/pci-common.c                   |    1 +
>  arch/powerpc/kernel/prom_parse.c                   |   84 ----
>  arch/x86/Kconfig                                   |   24 +-
>  arch/x86/include/asm/apic.h                        |    6 +-
>  arch/x86/include/asm/apicdef.h                     |   12 +
>  arch/x86/include/asm/bootparam.h                   |    1 +
>  arch/x86/include/asm/e820.h                        |    2 +-
>  arch/x86/include/asm/io_apic.h                     |   44 ++-
>  arch/x86/include/asm/irq.h                         |    3 -
>  arch/x86/include/asm/irq_controller.h              |   12 +
>  arch/x86/include/asm/olpc_ofw.h                    |   14 +-
>  arch/x86/include/asm/prom.h                        |   70 +++-
>  arch/x86/include/asm/x86_init.h                    |    2 +
>  arch/x86/kernel/Makefile                           |    5 +-
>  arch/x86/kernel/apb_timer.c                        |   60 +---
>  arch/x86/kernel/apic/apic.c                        |   74 ++--
>  arch/x86/kernel/apic/io_apic.c                     |  265 +++++-------
>  arch/x86/kernel/devicetree.c                       |  441 ++++++++++++++++++++
>  arch/x86/kernel/e820.c                             |    8 +-
>  arch/x86/kernel/head_32.S                          |    2 +-
>  arch/x86/kernel/irq.c                              |    9 -
>  arch/x86/kernel/irqinit.c                          |    9 +-
>  arch/x86/kernel/rtc.c                              |    3 +
>  arch/x86/kernel/setup.c                            |   25 +-
>  arch/x86/kernel/smpboot.c                          |   11 +-
>  arch/x86/kernel/x86_init.c                         |    1 +
>  arch/x86/pci/ce4100.c                              |    2 +-
>  arch/x86/platform/ce4100/ce4100.c                  |   24 +-
>  arch/x86/platform/ce4100/falconfalls.dts           |  428 +++++++++++++++++++
>  arch/x86/platform/mrst/mrst.c                      |    2 +
>  arch/x86/platform/mrst/vrtc.c                      |   16 +-
>  arch/x86/platform/olpc/Makefile                    |    4 +-
>  drivers/i2c/busses/i2c-ocores.c                    |   14 +-
>  drivers/i2c/i2c-core.c                             |    2 -
>  drivers/mmc/host/mmc_spi.c                         |    4 -
>  drivers/net/ethoc.c                                |    8 +-
>  drivers/of/Kconfig                                 |    6 +
>  drivers/of/Makefile                                |    1 +
>  drivers/of/of_pci.c                                |   92 ++++
>  drivers/rtc/rtc-cmos.c                             |   45 ++
>  drivers/rtc/rtc-mrst.c                             |   13 +-
>  drivers/spi/pxa2xx_spi.c                           |    2 -
>  drivers/spi/pxa2xx_spi_pci.c                       |    2 -
>  drivers/spi/xilinx_spi.c                           |    6 -
>  include/linux/device.h                             |    7 +-
>  include/linux/i2c.h                                |    2 -
>  include/linux/of.h                                 |   16 +-
>  include/linux/of_pci.h                             |    9 +
>  60 files changed, 1641 insertions(+), 593 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/i2c/ce4100-i2c.txt
>  create mode 100644 Documentation/devicetree/bindings/rtc/rtc-cmos.txt
>  create mode 100644 Documentation/devicetree/bindings/x86/ce4100.txt
>  create mode 100644 Documentation/devicetree/bindings/x86/interrupt.txt
>  create mode 100644 Documentation/devicetree/bindings/x86/timer.txt
>  create mode 100644 arch/x86/include/asm/irq_controller.h
>  create mode 100644 arch/x86/kernel/devicetree.c
>  create mode 100644 arch/x86/platform/ce4100/falconfalls.dts
>  create mode 100644 drivers/of/of_pci.c
>  create mode 100644 include/linux/of_pci.h
> 
> diff --git a/Documentation/devicetree/bindings/i2c/ce4100-i2c.txt b/Documentation/devicetree/bindings/i2c/ce4100-i2c.txt
> new file mode 100644
> index 0000000..569b162
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/i2c/ce4100-i2c.txt
> @@ -0,0 +1,93 @@
> +CE4100 I2C
> +----------
> +
> +CE4100 has one PCI device which is described as the I2C-Controller. This
> +PCI device has three PCI-bars, each bar contains a complete I2C
> +controller. So we have a total of three independent I2C-Controllers
> +which share only an interrupt line.
> +The driver is probed via the PCI-ID and is gathering the information of
> +attached devices from the devices tree.
> +Grant Likely recommended to use the ranges property to map the PCI-Bar
> +number to its physical address and to use this to find the child nodes
> +of the specific I2C controller. This were his exact words:
> +
> +       Here's where the magic happens.  Each entry in
> +       ranges describes how the parent pci address space
> +       (middle group of 3) is translated to the local
> +       address space (first group of 2) and the size of
> +       each range (last cell).  In this particular case,
> +       the first cell of the local address is chosen to be
> +       1:1 mapped to the BARs, and the second is the
> +       offset from be base of the BAR (which would be
> +       non-zero if you had 2 or more devices mapped off
> +       the same BAR)
> +
> +       ranges allows the address mapping to be described
> +       in a way that the OS can interpret without
> +       requiring custom device driver code.
> +
> +This is an example which is used on FalconFalls:
> +------------------------------------------------
> +	i2c-controller@b,2 {
> +		#address-cells = <2>;
> +		#size-cells = <1>;
> +		compatible = "pci8086,2e68.2",
> +				"pci8086,2e68",
> +				"pciclass,ff0000",
> +				"pciclass,ff00";
> +
> +		reg = <0x15a00 0x0 0x0 0x0 0x0>;
> +		interrupts = <16 1>;
> +
> +		/* as described by Grant, the first number in the group of
> +		* three is the bar number followed by the 64bit bar address
> +		* followed by size of the mapping. The bar address
> +		* requires also a valid translation in parents ranges
> +		* property.
> +		*/
> +		ranges = <0 0   0x02000000 0 0xdffe0500 0x100
> +			  1 0   0x02000000 0 0xdffe0600 0x100
> +			  2 0   0x02000000 0 0xdffe0700 0x100>;
> +
> +		i2c@0 {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			compatible = "intel,ce4100-i2c-controller";
> +
> +			/* The first number in the reg property is the
> +			* number of the bar
> +			*/
> +			reg = <0 0 0x100>;
> +
> +			/* This I2C controller has no devices */
> +		};
> +
> +		i2c@1 {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			compatible = "intel,ce4100-i2c-controller";
> +			reg = <1 0 0x100>;
> +
> +			/* This I2C controller has one gpio controller */
> +			gpio@26 {
> +				#gpio-cells = <2>;
> +				compatible = "ti,pcf8575";
> +				reg = <0x26>;
> +				gpio-controller;
> +			};
> +		};
> +
> +		i2c@2 {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			compatible = "intel,ce4100-i2c-controller";
> +			reg = <2 0 0x100>;
> +
> +			gpio@26 {
> +				#gpio-cells = <2>;
> +				compatible = "ti,pcf8575";
> +				reg = <0x26>;
> +				gpio-controller;
> +			};
> +		};
> +	};
> diff --git a/Documentation/devicetree/bindings/rtc/rtc-cmos.txt b/Documentation/devicetree/bindings/rtc/rtc-cmos.txt
> new file mode 100644
> index 0000000..7382989
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rtc/rtc-cmos.txt
> @@ -0,0 +1,28 @@
> + Motorola mc146818 compatible RTC
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +Required properties:
> +  - compatible : "motorola,mc146818"
> +  - reg : should contain registers location and length.
> +
> +Optional properties:
> +  - interrupts : should contain interrupt.
> +  - interrupt-parent : interrupt source phandle.
> +  - ctrl-reg : Contains the initial value of the control register also
> +    called "Register B".
> +  - freq-reg : Contains the initial value of the frequency register also
> +    called "Regsiter A".
> +
> +"Register A" and "B" are usually initialized by the firmware (BIOS for
> +instance). If this is not done, it can be performed by the driver.
> +
> +ISA Example:
> +
> +	rtc@70 {
> +	         compatible = "motorola,mc146818";
> +	         interrupts = <8 3>;
> +	         interrupt-parent = <&ioapic1>;
> +	         ctrl-reg = <2>;
> +	         freq-reg = <0x26>;
> +	         reg = <1 0x70 2>;
> +	 };
> diff --git a/Documentation/devicetree/bindings/x86/ce4100.txt b/Documentation/devicetree/bindings/x86/ce4100.txt
> new file mode 100644
> index 0000000..b49ae59
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/x86/ce4100.txt
> @@ -0,0 +1,38 @@
> +CE4100 Device Tree Bindings
> +---------------------------
> +
> +The CE4100 SoC uses for in core peripherals the following compatible
> +format: <vendor>,<chip>-<device>.
> +Many of the "generic" devices like HPET or IO APIC have the ce4100
> +name in their compatible property because they first appeared in this
> +SoC.
> +
> +The CPU node
> +------------
> +	cpu@0 {
> +		device_type = "cpu";
> +		compatible = "intel,ce4100";
> +		reg = <0>;
> +		lapic = <&lapic0>;
> +	};
> +
> +The reg property describes the CPU number. The lapic property points to
> +the local APIC timer.
> +
> +The SoC node
> +------------
> +
> +This node describes the in-core peripherals. Required property:
> +  compatible = "intel,ce4100-cp";
> +
> +The PCI node
> +------------
> +This node describes the PCI bus on the SoC. Its property should be
> +  compatible = "intel,ce4100-pci", "pci";
> +
> +If the OS is using the IO-APIC for interrupt routing then the reported
> +interrupt numbers for devices is no longer true. In order to obtain the
> +correct interrupt number, the child node which represents the device has
> +to contain the interrupt property. Besides the interrupt property it has
> +to contain at least the reg property containing the PCI bus address and
> +compatible property according to "PCI Bus Binding Revision 2.1".
> diff --git a/Documentation/devicetree/bindings/x86/interrupt.txt b/Documentation/devicetree/bindings/x86/interrupt.txt
> new file mode 100644
> index 0000000..7d19f49
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/x86/interrupt.txt
> @@ -0,0 +1,26 @@
> +Interrupt chips
> +---------------
> +
> +* Intel I/O Advanced Programmable Interrupt Controller (IO APIC)
> +
> +  Required properties:
> +  --------------------
> +     compatible = "intel,ce4100-ioapic";
> +     #interrupt-cells = <2>;
> +
> +  Device's interrupt property:
> +
> +     interrupts = <P S>;
> +
> +  The first number (P) represents the interrupt pin which is wired to the
> +  IO APIC. The second number (S) represents the sense of interrupt which
> +  should be configured and can be one of:
> +    0 - Edge Rising
> +    1 - Level Low
> +    2 - Level High
> +    3 - Edge Falling
> +
> +* Local APIC
> +  Required property:
> +
> +     compatible = "intel,ce4100-lapic";
> diff --git a/Documentation/devicetree/bindings/x86/timer.txt b/Documentation/devicetree/bindings/x86/timer.txt
> new file mode 100644
> index 0000000..c688af5
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/x86/timer.txt
> @@ -0,0 +1,6 @@
> +Timers
> +------
> +
> +* High Precision Event Timer (HPET)
> +  Required property:
> +     compatible = "intel,ce4100-hpet";
> diff --git a/Documentation/devicetree/booting-without-of.txt b/Documentation/devicetree/booting-without-of.txt
> index 28b1c9d..55fd262 100644
> --- a/Documentation/devicetree/booting-without-of.txt
> +++ b/Documentation/devicetree/booting-without-of.txt
> @@ -13,6 +13,7 @@ Table of Contents
>  
>    I - Introduction
>      1) Entry point for arch/powerpc
> +    2) Entry point for arch/x86
>  
>    II - The DT block format
>      1) Header
> @@ -225,6 +226,25 @@ it with special cases.
>    cannot support both configurations with Book E and configurations
>    with classic Powerpc architectures.
>  
> +2) Entry point for arch/x86
> +-------------------------------
> +
> +  There is one single 32bit entry point to the kernel at code32_start,
> +  the decompressor (the real mode entry point goes to the same  32bit
> +  entry point once it switched into protected mode). That entry point
> +  supports one calling convention which is documented in
> +  Documentation/x86/boot.txt
> +  The physical pointer to the device-tree block (defined in chapter II)
> +  is passed via setup_data which requires at least boot protocol 2.09.
> +  The type filed is defined as
> +
> +  #define SETUP_DTB                      2
> +
> +  This device-tree is used as an extension to the "boot page". As such it
> +  does not parse / consider data which is already covered by the boot
> +  page. This includes memory size, reserved ranges, command line arguments
> +  or initrd address. It simply holds information which can not be retrieved
> +  otherwise like interrupt routing or a list of devices behind an I2C bus.
>  
>  II - The DT block format
>  ========================
> diff --git a/arch/microblaze/include/asm/pci-bridge.h b/arch/microblaze/include/asm/pci-bridge.h
> index 0c68764..1071766 100644
> --- a/arch/microblaze/include/asm/pci-bridge.h
> +++ b/arch/microblaze/include/asm/pci-bridge.h
> @@ -104,11 +104,22 @@ struct pci_controller {
>  	int global_number;	/* PCI domain number */
>  };
>  
> +#ifdef CONFIG_PCI
>  static inline struct pci_controller *pci_bus_to_host(const struct pci_bus *bus)
>  {
>  	return bus->sysdata;
>  }
>  
> +static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
> +{
> +	struct pci_controller *host;
> +
> +	if (bus->self)
> +		return pci_device_to_OF_node(bus->self);
> +	host = pci_bus_to_host(bus);
> +	return host ? host->dn : NULL;
> +}
> +
>  static inline int isa_vaddr_is_ioport(void __iomem *address)
>  {
>  	/* No specific ISA handling on ppc32 at this stage, it
> @@ -116,6 +127,7 @@ static inline int isa_vaddr_is_ioport(void __iomem *address)
>  	 */
>  	return 0;
>  }
> +#endif /* CONFIG_PCI */
>  
>  /* These are used for config access before all the PCI probing
>     has been done. */
> diff --git a/arch/microblaze/include/asm/prom.h b/arch/microblaze/include/asm/prom.h
> index 2e72af0..d0890d3 100644
> --- a/arch/microblaze/include/asm/prom.h
> +++ b/arch/microblaze/include/asm/prom.h
> @@ -64,21 +64,6 @@ extern void kdump_move_device_tree(void);
>  /* CPU OF node matching */
>  struct device_node *of_get_cpu_node(int cpu, unsigned int *thread);
>  
> -/**
> - * of_irq_map_pci - Resolve the interrupt for a PCI device
> - * @pdev:	the device whose interrupt is to be resolved
> - * @out_irq:	structure of_irq filled by this function
> - *
> - * This function resolves the PCI interrupt for a given PCI device. If a
> - * device-node exists for a given pci_dev, it will use normal OF tree
> - * walking. If not, it will implement standard swizzling and walk up the
> - * PCI tree until an device-node is found, at which point it will finish
> - * resolving using the OF tree walking.
> - */
> -struct pci_dev;
> -struct of_irq;
> -extern int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq);
> -
>  #endif /* __ASSEMBLY__ */
>  #endif /* __KERNEL__ */
>  
> diff --git a/arch/microblaze/kernel/prom_parse.c b/arch/microblaze/kernel/prom_parse.c
> index 9ae24f4..47187cc 100644
> --- a/arch/microblaze/kernel/prom_parse.c
> +++ b/arch/microblaze/kernel/prom_parse.c
> @@ -2,88 +2,11 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/string.h>
> -#include <linux/pci_regs.h>
>  #include <linux/module.h>
>  #include <linux/ioport.h>
>  #include <linux/etherdevice.h>
>  #include <linux/of_address.h>
>  #include <asm/prom.h>
> -#include <asm/pci-bridge.h>
> -
> -#ifdef CONFIG_PCI
> -int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq)
> -{
> -	struct device_node *dn, *ppnode;
> -	struct pci_dev *ppdev;
> -	u32 lspec;
> -	u32 laddr[3];
> -	u8 pin;
> -	int rc;
> -
> -	/* Check if we have a device node, if yes, fallback to standard OF
> -	 * parsing
> -	 */
> -	dn = pci_device_to_OF_node(pdev);
> -	if (dn)
> -		return of_irq_map_one(dn, 0, out_irq);
> -
> -	/* Ok, we don't, time to have fun. Let's start by building up an
> -	 * interrupt spec.  we assume #interrupt-cells is 1, which is standard
> -	 * for PCI. If you do different, then don't use that routine.
> -	 */
> -	rc = pci_read_config_byte(pdev, PCI_INTERRUPT_PIN, &pin);
> -	if (rc != 0)
> -		return rc;
> -	/* No pin, exit */
> -	if (pin == 0)
> -		return -ENODEV;
> -
> -	/* Now we walk up the PCI tree */
> -	lspec = pin;
> -	for (;;) {
> -		/* Get the pci_dev of our parent */
> -		ppdev = pdev->bus->self;
> -
> -		/* Ouch, it's a host bridge... */
> -		if (ppdev == NULL) {
> -			struct pci_controller *host;
> -			host = pci_bus_to_host(pdev->bus);
> -			ppnode = host ? host->dn : NULL;
> -			/* No node for host bridge ? give up */
> -			if (ppnode == NULL)
> -				return -EINVAL;
> -		} else
> -			/* We found a P2P bridge, check if it has a node */
> -			ppnode = pci_device_to_OF_node(ppdev);
> -
> -		/* Ok, we have found a parent with a device-node, hand over to
> -		 * the OF parsing code.
> -		 * We build a unit address from the linux device to be used for
> -		 * resolution. Note that we use the linux bus number which may
> -		 * not match your firmware bus numbering.
> -		 * Fortunately, in most cases, interrupt-map-mask doesn't
> -		 * include the bus number as part of the matching.
> -		 * You should still be careful about that though if you intend
> -		 * to rely on this function (you ship  a firmware that doesn't
> -		 * create device nodes for all PCI devices).
> -		 */
> -		if (ppnode)
> -			break;
> -
> -		/* We can only get here if we hit a P2P bridge with no node,
> -		 * let's do standard swizzling and try again
> -		 */
> -		lspec = pci_swizzle_interrupt_pin(pdev, lspec);
> -		pdev = ppdev;
> -	}
> -
> -	laddr[0] = (pdev->bus->number << 16)
> -		| (pdev->devfn << 8);
> -	laddr[1]  = laddr[2] = 0;
> -	return of_irq_map_raw(ppnode, &lspec, 1, laddr, out_irq);
> -}
> -EXPORT_SYMBOL_GPL(of_irq_map_pci);
> -#endif /* CONFIG_PCI */
>  
>  void of_parse_dma_window(struct device_node *dn, const void *dma_window_prop,
>  		unsigned long *busno, unsigned long *phys, unsigned long *size)
> diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
> index e363615..1e01a12 100644
> --- a/arch/microblaze/pci/pci-common.c
> +++ b/arch/microblaze/pci/pci-common.c
> @@ -29,6 +29,7 @@
>  #include <linux/slab.h>
>  #include <linux/of.h>
>  #include <linux/of_address.h>
> +#include <linux/of_pci.h>
>  
>  #include <asm/processor.h>
>  #include <asm/io.h>
> diff --git a/arch/powerpc/include/asm/pci-bridge.h b/arch/powerpc/include/asm/pci-bridge.h
> index 51e9e6f..edeb80f 100644
> --- a/arch/powerpc/include/asm/pci-bridge.h
> +++ b/arch/powerpc/include/asm/pci-bridge.h
> @@ -171,6 +171,16 @@ static inline struct pci_controller *pci_bus_to_host(const struct pci_bus *bus)
>  	return bus->sysdata;
>  }
>  
> +static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
> +{
> +	struct pci_controller *host;
> +
> +	if (bus->self)
> +		return pci_device_to_OF_node(bus->self);
> +	host = pci_bus_to_host(bus);
> +	return host ? host->dn : NULL;
> +}
> +
>  static inline int isa_vaddr_is_ioport(void __iomem *address)
>  {
>  	/* No specific ISA handling on ppc32 at this stage, it
> diff --git a/arch/powerpc/include/asm/prom.h b/arch/powerpc/include/asm/prom.h
> index d727575..c189aa5 100644
> --- a/arch/powerpc/include/asm/prom.h
> +++ b/arch/powerpc/include/asm/prom.h
> @@ -70,21 +70,6 @@ static inline int of_node_to_nid(struct device_node *device) { return 0; }
>  #endif
>  #define of_node_to_nid of_node_to_nid
>  
> -/**
> - * of_irq_map_pci - Resolve the interrupt for a PCI device
> - * @pdev:	the device whose interrupt is to be resolved
> - * @out_irq:	structure of_irq filled by this function
> - *
> - * This function resolves the PCI interrupt for a given PCI device. If a
> - * device-node exists for a given pci_dev, it will use normal OF tree
> - * walking. If not, it will implement standard swizzling and walk up the
> - * PCI tree until an device-node is found, at which point it will finish
> - * resolving using the OF tree walking.
> - */
> -struct pci_dev;
> -struct of_irq;
> -extern int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq);
> -
>  extern void of_instantiate_rtc(void);
>  
>  /* These includes are put at the bottom because they may contain things
> diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
> index 10a44e6..eb341be 100644
> --- a/arch/powerpc/kernel/pci-common.c
> +++ b/arch/powerpc/kernel/pci-common.c
> @@ -22,6 +22,7 @@
>  #include <linux/init.h>
>  #include <linux/bootmem.h>
>  #include <linux/of_address.h>
> +#include <linux/of_pci.h>
>  #include <linux/mm.h>
>  #include <linux/list.h>
>  #include <linux/syscalls.h>
> diff --git a/arch/powerpc/kernel/prom_parse.c b/arch/powerpc/kernel/prom_parse.c
> index c2b7a07..47187cc 100644
> --- a/arch/powerpc/kernel/prom_parse.c
> +++ b/arch/powerpc/kernel/prom_parse.c
> @@ -2,95 +2,11 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/string.h>
> -#include <linux/pci_regs.h>
>  #include <linux/module.h>
>  #include <linux/ioport.h>
>  #include <linux/etherdevice.h>
>  #include <linux/of_address.h>
>  #include <asm/prom.h>
> -#include <asm/pci-bridge.h>
> -
> -#ifdef CONFIG_PCI
> -int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq)
> -{
> -	struct device_node *dn, *ppnode;
> -	struct pci_dev *ppdev;
> -	u32 lspec;
> -	u32 laddr[3];
> -	u8 pin;
> -	int rc;
> -
> -	/* Check if we have a device node, if yes, fallback to standard OF
> -	 * parsing
> -	 */
> -	dn = pci_device_to_OF_node(pdev);
> -	if (dn) {
> -		rc = of_irq_map_one(dn, 0, out_irq);
> -		if (!rc)
> -			return rc;
> -	}
> -
> -	/* Ok, we don't, time to have fun. Let's start by building up an
> -	 * interrupt spec.  we assume #interrupt-cells is 1, which is standard
> -	 * for PCI. If you do different, then don't use that routine.
> -	 */
> -	rc = pci_read_config_byte(pdev, PCI_INTERRUPT_PIN, &pin);
> -	if (rc != 0)
> -		return rc;
> -	/* No pin, exit */
> -	if (pin == 0)
> -		return -ENODEV;
> -
> -	/* Now we walk up the PCI tree */
> -	lspec = pin;
> -	for (;;) {
> -		/* Get the pci_dev of our parent */
> -		ppdev = pdev->bus->self;
> -
> -		/* Ouch, it's a host bridge... */
> -		if (ppdev == NULL) {
> -#ifdef CONFIG_PPC64
> -			ppnode = pci_bus_to_OF_node(pdev->bus);
> -#else
> -			struct pci_controller *host;
> -			host = pci_bus_to_host(pdev->bus);
> -			ppnode = host ? host->dn : NULL;
> -#endif
> -			/* No node for host bridge ? give up */
> -			if (ppnode == NULL)
> -				return -EINVAL;
> -		} else
> -			/* We found a P2P bridge, check if it has a node */
> -			ppnode = pci_device_to_OF_node(ppdev);
> -
> -		/* Ok, we have found a parent with a device-node, hand over to
> -		 * the OF parsing code.
> -		 * We build a unit address from the linux device to be used for
> -		 * resolution. Note that we use the linux bus number which may
> -		 * not match your firmware bus numbering.
> -		 * Fortunately, in most cases, interrupt-map-mask doesn't include
> -		 * the bus number as part of the matching.
> -		 * You should still be careful about that though if you intend
> -		 * to rely on this function (you ship  a firmware that doesn't
> -		 * create device nodes for all PCI devices).
> -		 */
> -		if (ppnode)
> -			break;
> -
> -		/* We can only get here if we hit a P2P bridge with no node,
> -		 * let's do standard swizzling and try again
> -		 */
> -		lspec = pci_swizzle_interrupt_pin(pdev, lspec);
> -		pdev = ppdev;
> -	}
> -
> -	laddr[0] = (pdev->bus->number << 16)
> -		| (pdev->devfn << 8);
> -	laddr[1]  = laddr[2] = 0;
> -	return of_irq_map_raw(ppnode, &lspec, 1, laddr, out_irq);
> -}
> -EXPORT_SYMBOL_GPL(of_irq_map_pci);
> -#endif /* CONFIG_PCI */
>  
>  void of_parse_dma_window(struct device_node *dn, const void *dma_window_prop,
>  		unsigned long *busno, unsigned long *phys, unsigned long *size)
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index d5ed94d..b4c2e9c 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -382,6 +382,8 @@ config X86_INTEL_CE
>  	depends on X86_32
>  	depends on X86_EXTENDED_PLATFORM
>  	select X86_REBOOTFIXUPS
> +	select OF
> +	select OF_EARLY_FLATTREE
>  	---help---
>  	  Select for the Intel CE media processor (CE4100) SOC.
>  	  This option compiles in support for the CE4100 SOC for settop
> @@ -811,7 +813,7 @@ config X86_LOCAL_APIC
>  
>  config X86_IO_APIC
>  	def_bool y
> -	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_APIC
> +	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_IOAPIC
>  
>  config X86_VISWS_APIC
>  	def_bool y
> @@ -2066,9 +2068,10 @@ config SCx200HR_TIMER
>  
>  config OLPC
>  	bool "One Laptop Per Child support"
> +	depends on !X86_PAE
>  	select GPIOLIB
> -	select OLPC_OPENFIRMWARE
> -	depends on !X86_64 && !X86_PAE
> +	select OF
> +	select OF_PROMTREE if PROC_DEVICETREE
>  	---help---
>  	  Add support for detecting the unique features of the OLPC
>  	  XO hardware.
> @@ -2079,21 +2082,6 @@ config OLPC_XO1
>  	---help---
>  	  Add support for non-essential features of the OLPC XO-1 laptop.
>  
> -config OLPC_OPENFIRMWARE
> -	bool "Support for OLPC's Open Firmware"
> -	depends on !X86_64 && !X86_PAE
> -	default n
> -	select OF
> -	help
> -	  This option adds support for the implementation of Open Firmware
> -	  that is used on the OLPC XO-1 Children's Machine.
> -	  If unsure, say N here.
> -
> -config OLPC_OPENFIRMWARE_DT
> -	bool
> -	default y if OLPC_OPENFIRMWARE && PROC_DEVICETREE
> -	select OF_PROMTREE
> -
>  endif # X86_32
>  
>  config AMD_NB
> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index 3c89694..5b7d513 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -220,7 +220,6 @@ extern void enable_IR_x2apic(void);
>  
>  extern int get_physical_broadcast(void);
>  
> -extern void apic_disable(void);
>  extern int lapic_get_maxlvt(void);
>  extern void clear_local_APIC(void);
>  extern void connect_bsp_APIC(void);
> @@ -228,7 +227,6 @@ extern void disconnect_bsp_APIC(int virt_wire_setup);
>  extern void disable_local_APIC(void);
>  extern void lapic_shutdown(void);
>  extern int verify_local_APIC(void);
> -extern void cache_APIC_registers(void);
>  extern void sync_Arb_IDs(void);
>  extern void init_bsp_APIC(void);
>  extern void setup_local_APIC(void);
> @@ -239,8 +237,7 @@ void register_lapic_address(unsigned long address);
>  extern void setup_boot_APIC_clock(void);
>  extern void setup_secondary_APIC_clock(void);
>  extern int APIC_init_uniprocessor(void);
> -extern void enable_NMI_through_LVT0(void);
> -extern int apic_force_enable(void);
> +extern int apic_force_enable(unsigned long addr);
>  
>  /*
>   * On 32bit this is mach-xxx local
> @@ -261,7 +258,6 @@ static inline void lapic_shutdown(void) { }
>  #define local_apic_timer_c2_ok		1
>  static inline void init_apic_mappings(void) { }
>  static inline void disable_local_APIC(void) { }
> -static inline void apic_disable(void) { }
>  # define setup_boot_APIC_clock x86_init_noop
>  # define setup_secondary_APIC_clock x86_init_noop
>  #endif /* !CONFIG_X86_LOCAL_APIC */
> diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
> index 47a30ff..d87988b 100644
> --- a/arch/x86/include/asm/apicdef.h
> +++ b/arch/x86/include/asm/apicdef.h
> @@ -426,4 +426,16 @@ struct local_apic {
>  #else
>   #define BAD_APICID 0xFFFFu
>  #endif
> +
> +enum ioapic_irq_destination_types {
> +	dest_Fixed		= 0,
> +	dest_LowestPrio		= 1,
> +	dest_SMI		= 2,
> +	dest__reserved_1	= 3,
> +	dest_NMI		= 4,
> +	dest_INIT		= 5,
> +	dest__reserved_2	= 6,
> +	dest_ExtINT		= 7
> +};
> +
>  #endif /* _ASM_X86_APICDEF_H */
> diff --git a/arch/x86/include/asm/bootparam.h b/arch/x86/include/asm/bootparam.h
> index c8bfe63..e020d88 100644
> --- a/arch/x86/include/asm/bootparam.h
> +++ b/arch/x86/include/asm/bootparam.h
> @@ -12,6 +12,7 @@
>  /* setup data types */
>  #define SETUP_NONE			0
>  #define SETUP_E820_EXT			1
> +#define SETUP_DTB			2
>  
>  /* extensible setup data list node */
>  struct setup_data {
> diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
> index e99d55d..908b969 100644
> --- a/arch/x86/include/asm/e820.h
> +++ b/arch/x86/include/asm/e820.h
> @@ -96,7 +96,7 @@ extern void e820_setup_gap(void);
>  extern int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
>  			unsigned long start_addr, unsigned long long end_addr);
>  struct setup_data;
> -extern void parse_e820_ext(struct setup_data *data, unsigned long pa_data);
> +extern void parse_e820_ext(struct setup_data *data);
>  
>  #if defined(CONFIG_X86_64) || \
>  	(defined(CONFIG_X86_32) && defined(CONFIG_HIBERNATION))
> diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
> index f327d38..c4bd267 100644
> --- a/arch/x86/include/asm/io_apic.h
> +++ b/arch/x86/include/asm/io_apic.h
> @@ -63,17 +63,6 @@ union IO_APIC_reg_03 {
>  	} __attribute__ ((packed)) bits;
>  };
>  
> -enum ioapic_irq_destination_types {
> -	dest_Fixed = 0,
> -	dest_LowestPrio = 1,
> -	dest_SMI = 2,
> -	dest__reserved_1 = 3,
> -	dest_NMI = 4,
> -	dest_INIT = 5,
> -	dest__reserved_2 = 6,
> -	dest_ExtINT = 7
> -};
> -
>  struct IO_APIC_route_entry {
>  	__u32	vector		:  8,
>  		delivery_mode	:  3,	/* 000: FIXED
> @@ -106,6 +95,10 @@ struct IR_IO_APIC_route_entry {
>  		index		: 15;
>  } __attribute__ ((packed));
>  
> +#define IOAPIC_AUTO     -1
> +#define IOAPIC_EDGE     0
> +#define IOAPIC_LEVEL    1
> +
>  #ifdef CONFIG_X86_IO_APIC
>  
>  /*
> @@ -150,11 +143,6 @@ extern int timer_through_8259;
>  #define io_apic_assign_pci_irqs \
>  	(mp_irq_entries && !skip_ioapic_setup && io_apic_irqs)
>  
> -extern u8 io_apic_unique_id(u8 id);
> -extern int io_apic_get_unique_id(int ioapic, int apic_id);
> -extern int io_apic_get_version(int ioapic);
> -extern int io_apic_get_redir_entries(int ioapic);
> -
>  struct io_apic_irq_attr;
>  extern int io_apic_set_pci_routing(struct device *dev, int irq,
>  		 struct io_apic_irq_attr *irq_attr);
> @@ -162,6 +150,8 @@ void setup_IO_APIC_irq_extra(u32 gsi);
>  extern void ioapic_and_gsi_init(void);
>  extern void ioapic_insert_resources(void);
>  
> +int io_apic_setup_irq_pin(unsigned int irq, int node, struct io_apic_irq_attr *attr);
> +
>  extern struct IO_APIC_route_entry **alloc_ioapic_entries(void);
>  extern void free_ioapic_entries(struct IO_APIC_route_entry **ioapic_entries);
>  extern int save_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
> @@ -186,6 +176,8 @@ extern void __init pre_init_apic_IRQ0(void);
>  
>  extern void mp_save_irq(struct mpc_intsrc *m);
>  
> +extern void disable_ioapic_support(void);
> +
>  #else  /* !CONFIG_X86_IO_APIC */
>  
>  #define io_apic_assign_pci_irqs 0
> @@ -199,6 +191,26 @@ static inline int mp_find_ioapic(u32 gsi) { return 0; }
>  struct io_apic_irq_attr;
>  static inline int io_apic_set_pci_routing(struct device *dev, int irq,
>  		 struct io_apic_irq_attr *irq_attr) { return 0; }
> +
> +static inline struct IO_APIC_route_entry **alloc_ioapic_entries(void)
> +{
> +	return NULL;
> +}
> +
> +static inline void free_ioapic_entries(struct IO_APIC_route_entry **ent) { }
> +static inline int save_IO_APIC_setup(struct IO_APIC_route_entry **ent)
> +{
> +	return -ENOMEM;
> +}
> +
> +static inline void mask_IO_APIC_setup(struct IO_APIC_route_entry **ent) { }
> +static inline int restore_IO_APIC_setup(struct IO_APIC_route_entry **ent)
> +{
> +	return -ENOMEM;
> +}
> +
> +static inline void mp_save_irq(struct mpc_intsrc *m) { };
> +static inline void disable_ioapic_support(void) { }
>  #endif
>  
>  #endif /* _ASM_X86_IO_APIC_H */
> diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
> index c704b38..ba870bb 100644
> --- a/arch/x86/include/asm/irq.h
> +++ b/arch/x86/include/asm/irq.h
> @@ -10,9 +10,6 @@
>  #include <asm/apicdef.h>
>  #include <asm/irq_vectors.h>
>  
> -/* Even though we don't support this, supply it to appease OF */
> -static inline void irq_dispose_mapping(unsigned int virq) { }
> -
>  static inline int irq_canonicalize(int irq)
>  {
>  	return ((irq == 2) ? 9 : irq);
> diff --git a/arch/x86/include/asm/irq_controller.h b/arch/x86/include/asm/irq_controller.h
> new file mode 100644
> index 0000000..423bbbd
> --- /dev/null
> +++ b/arch/x86/include/asm/irq_controller.h
> @@ -0,0 +1,12 @@
> +#ifndef __IRQ_CONTROLLER__
> +#define __IRQ_CONTROLLER__
> +
> +struct irq_domain {
> +	int (*xlate)(struct irq_domain *h, const u32 *intspec, u32 intsize,
> +			u32 *out_hwirq, u32 *out_type);
> +	void *priv;
> +	struct device_node *controller;
> +	struct list_head l;
> +};
> +
> +#endif
> diff --git a/arch/x86/include/asm/olpc_ofw.h b/arch/x86/include/asm/olpc_ofw.h
> index 641988e..c5d3a5a 100644
> --- a/arch/x86/include/asm/olpc_ofw.h
> +++ b/arch/x86/include/asm/olpc_ofw.h
> @@ -6,7 +6,7 @@
>  
>  #define OLPC_OFW_SIG 0x2057464F	/* aka "OFW " */
>  
> -#ifdef CONFIG_OLPC_OPENFIRMWARE
> +#ifdef CONFIG_OLPC
>  
>  extern bool olpc_ofw_is_installed(void);
>  
> @@ -26,19 +26,15 @@ extern void setup_olpc_ofw_pgd(void);
>  /* check if OFW was detected during boot */
>  extern bool olpc_ofw_present(void);
>  
> -#else /* !CONFIG_OLPC_OPENFIRMWARE */
> -
> -static inline bool olpc_ofw_is_installed(void) { return false; }
> +#else /* !CONFIG_OLPC */
>  static inline void olpc_ofw_detect(void) { }
>  static inline void setup_olpc_ofw_pgd(void) { }
> -static inline bool olpc_ofw_present(void) { return false; }
> -
> -#endif /* !CONFIG_OLPC_OPENFIRMWARE */
> +#endif /* !CONFIG_OLPC */
>  
> -#ifdef CONFIG_OLPC_OPENFIRMWARE_DT
> +#ifdef CONFIG_OF_PROMTREE
>  extern void olpc_dt_build_devicetree(void);
>  #else
>  static inline void olpc_dt_build_devicetree(void) { }
> -#endif /* CONFIG_OLPC_OPENFIRMWARE_DT */
> +#endif
>  
>  #endif /* _ASM_X86_OLPC_OFW_H */
> diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
> index b4ec95f..971e0b4 100644
> --- a/arch/x86/include/asm/prom.h
> +++ b/arch/x86/include/asm/prom.h
> @@ -1 +1,69 @@
> -/* dummy prom.h; here to make linux/of.h's #includes happy */
> +/*
> + * Definitions for Device tree / OpenFirmware handling on X86
> + *
> + * based on arch/powerpc/include/asm/prom.h which is
> + *         Copyright (C) 1996-2005 Paul Mackerras.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + */
> +
> +#ifndef _ASM_X86_PROM_H
> +#define _ASM_X86_PROM_H
> +#ifndef __ASSEMBLY__
> +
> +#include <linux/of.h>
> +#include <linux/types.h>
> +#include <linux/pci.h>
> +
> +#include <asm/irq.h>
> +#include <asm/atomic.h>
> +#include <asm/setup.h>
> +#include <asm/irq_controller.h>
> +
> +#ifdef CONFIG_OF
> +extern int of_ioapic;
> +extern u64 initial_dtb;
> +extern void add_dtb(u64 data);
> +extern void x86_add_irq_domains(void);
> +void __cpuinit x86_of_pci_init(void);
> +void x86_dtb_init(void);
> +
> +static inline struct device_node *pci_device_to_OF_node(struct pci_dev *pdev)
> +{
> +	return pdev ? pdev->dev.of_node : NULL;
> +}
> +
> +static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
> +{
> +	return pci_device_to_OF_node(bus->self);
> +}
> +
> +#else
> +static inline void add_dtb(u64 data) { }
> +static inline void x86_add_irq_domains(void) { }
> +static inline void x86_of_pci_init(void) { }
> +static inline void x86_dtb_init(void) { }
> +#define of_ioapic 0
> +#endif
> +
> +extern char cmd_line[COMMAND_LINE_SIZE];
> +
> +#define pci_address_to_pio pci_address_to_pio
> +unsigned long pci_address_to_pio(phys_addr_t addr);
> +
> +/**
> + * irq_dispose_mapping - Unmap an interrupt
> + * @virq: linux virq number of the interrupt to unmap
> + *
> + * FIXME: We really should implement proper virq handling like power,
> + * but that's going to be major surgery.
> + */
> +static inline void irq_dispose_mapping(unsigned int virq) { }
> +
> +#define HAVE_ARCH_DEVTREE_FIXUPS
> +
> +#endif /* __ASSEMBLY__ */
> +#endif
> diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
> index 64642ad..643ebf2 100644
> --- a/arch/x86/include/asm/x86_init.h
> +++ b/arch/x86/include/asm/x86_init.h
> @@ -83,11 +83,13 @@ struct x86_init_paging {
>   *				boot cpu
>   * @tsc_pre_init:		platform function called before TSC init
>   * @timer_init:			initialize the platform timer (default PIT/HPET)
> + * @wallclock_init:		init the wallclock device
>   */
>  struct x86_init_timers {
>  	void (*setup_percpu_clockev)(void);
>  	void (*tsc_pre_init)(void);
>  	void (*timer_init)(void);
> +	void (*wallclock_init)(void);
>  };
>  
>  /**
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 34244b2..62445ba 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -66,9 +66,9 @@ obj-$(CONFIG_PCI)		+= early-quirks.o
>  apm-y				:= apm_32.o
>  obj-$(CONFIG_APM)		+= apm.o
>  obj-$(CONFIG_SMP)		+= smp.o
> -obj-$(CONFIG_SMP)		+= smpboot.o tsc_sync.o
> +obj-$(CONFIG_SMP)		+= smpboot.o
> +obj-$(CONFIG_SMP)		+= tsc_sync.o
>  obj-$(CONFIG_SMP)		+= setup_percpu.o
> -obj-$(CONFIG_X86_64_SMP)	+= tsc_sync.o
>  obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_$(BITS).o
>  obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
>  obj-y				+= apic/
> @@ -109,6 +109,7 @@ obj-$(CONFIG_MICROCODE)			+= microcode.o
>  obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
>  
>  obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
> +obj-$(CONFIG_OF)			+= devicetree.o
>  
>  ###
>  # 64 bit specific files
> diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
> index 51ef31a..671d5aa 100644
> --- a/arch/x86/kernel/apb_timer.c
> +++ b/arch/x86/kernel/apb_timer.c
> @@ -508,64 +508,12 @@ static int apbt_next_event(unsigned long delta,
>  	return 0;
>  }
>  
> -/*
> - * APB timer clock is not in sync with pclk on Langwell, which translates to
> - * unreliable read value caused by sampling error. the error does not add up
> - * overtime and only happens when sampling a 0 as a 1 by mistake. so the time
> - * would go backwards. the following code is trying to prevent time traveling
> - * backwards. little bit paranoid.
> - */
>  static cycle_t apbt_read_clocksource(struct clocksource *cs)
>  {
> -	unsigned long t0, t1, t2;
> -	static unsigned long last_read;
> -
> -bad_count:
> -	t1 = apbt_readl(phy_cs_timer_id,
> -			APBTMR_N_CURRENT_VALUE);
> -	t2 = apbt_readl(phy_cs_timer_id,
> -			APBTMR_N_CURRENT_VALUE);
> -	if (unlikely(t1 < t2)) {
> -		pr_debug("APBT: read current count error %lx:%lx:%lx\n",
> -			 t1, t2, t2 - t1);
> -		goto bad_count;
> -	}
> -	/*
> -	 * check against cached last read, makes sure time does not go back.
> -	 * it could be a normal rollover but we will do tripple check anyway
> -	 */
> -	if (unlikely(t2 > last_read)) {
> -		/* check if we have a normal rollover */
> -		unsigned long raw_intr_status =
> -			apbt_readl_reg(APBTMRS_RAW_INT_STATUS);
> -		/*
> -		 * cs timer interrupt is masked but raw intr bit is set if
> -		 * rollover occurs. then we read EOI reg to clear it.
> -		 */
> -		if (raw_intr_status & (1 << phy_cs_timer_id)) {
> -			apbt_readl(phy_cs_timer_id, APBTMR_N_EOI);
> -			goto out;
> -		}
> -		pr_debug("APB CS going back %lx:%lx:%lx ",
> -			 t2, last_read, t2 - last_read);
> -bad_count_x3:
> -		pr_debug("triple check enforced\n");
> -		t0 = apbt_readl(phy_cs_timer_id,
> -				APBTMR_N_CURRENT_VALUE);
> -		udelay(1);
> -		t1 = apbt_readl(phy_cs_timer_id,
> -				APBTMR_N_CURRENT_VALUE);
> -		udelay(1);
> -		t2 = apbt_readl(phy_cs_timer_id,
> -				APBTMR_N_CURRENT_VALUE);
> -		if ((t2 > t1) || (t1 > t0)) {
> -			printk(KERN_ERR "Error: APB CS tripple check failed\n");
> -			goto bad_count_x3;
> -		}
> -	}
> -out:
> -	last_read = t2;
> -	return (cycle_t)~t2;
> +	unsigned long current_count;
> +
> +	current_count = apbt_readl(phy_cs_timer_id, APBTMR_N_CURRENT_VALUE);
> +	return (cycle_t)~current_count;
>  }
>  
>  static int apbt_clocksource_register(void)
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index 76b96d7..ffbf7c2 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -43,6 +43,7 @@
>  #include <asm/i8259.h>
>  #include <asm/proto.h>
>  #include <asm/apic.h>
> +#include <asm/io_apic.h>
>  #include <asm/desc.h>
>  #include <asm/hpet.h>
>  #include <asm/idle.h>
> @@ -83,7 +84,7 @@ EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
>   *
>   * +1=force-enable
>   */
> -static int force_enable_local_apic;
> +static int force_enable_local_apic __initdata;
>  /*
>   * APIC command line parameters
>   */
> @@ -153,7 +154,7 @@ early_param("nox2apic", setup_nox2apic);
>  unsigned long mp_lapic_addr;
>  int disable_apic;
>  /* Disable local APIC timer from the kernel commandline or via dmi quirk */
> -static int disable_apic_timer __cpuinitdata;
> +static int disable_apic_timer __initdata;
>  /* Local APIC timer works in C2 */
>  int local_apic_timer_c2_ok;
>  EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
> @@ -177,29 +178,8 @@ static struct resource lapic_resource = {
>  
>  static unsigned int calibration_result;
>  
> -static int lapic_next_event(unsigned long delta,
> -			    struct clock_event_device *evt);
> -static void lapic_timer_setup(enum clock_event_mode mode,
> -			      struct clock_event_device *evt);
> -static void lapic_timer_broadcast(const struct cpumask *mask);
>  static void apic_pm_activate(void);
>  
> -/*
> - * The local apic timer can be used for any function which is CPU local.
> - */
> -static struct clock_event_device lapic_clockevent = {
> -	.name		= "lapic",
> -	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT
> -			| CLOCK_EVT_FEAT_C3STOP | CLOCK_EVT_FEAT_DUMMY,
> -	.shift		= 32,
> -	.set_mode	= lapic_timer_setup,
> -	.set_next_event	= lapic_next_event,
> -	.broadcast	= lapic_timer_broadcast,
> -	.rating		= 100,
> -	.irq		= -1,
> -};
> -static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
> -
>  static unsigned long apic_phys;
>  
>  /*
> @@ -238,7 +218,7 @@ static int modern_apic(void)
>   * right after this call apic become NOOP driven
>   * so apic->write/read doesn't do anything
>   */
> -void apic_disable(void)
> +static void __init apic_disable(void)
>  {
>  	pr_info("APIC: switched to apic NOOP\n");
>  	apic = &apic_noop;
> @@ -282,23 +262,6 @@ u64 native_apic_icr_read(void)
>  	return icr1 | ((u64)icr2 << 32);
>  }
>  
> -/**
> - * enable_NMI_through_LVT0 - enable NMI through local vector table 0
> - */
> -void __cpuinit enable_NMI_through_LVT0(void)
> -{
> -	unsigned int v;
> -
> -	/* unmask and set to NMI */
> -	v = APIC_DM_NMI;
> -
> -	/* Level triggered for 82489DX (32bit mode) */
> -	if (!lapic_is_integrated())
> -		v |= APIC_LVT_LEVEL_TRIGGER;
> -
> -	apic_write(APIC_LVT0, v);
> -}
> -
>  #ifdef CONFIG_X86_32
>  /**
>   * get_physical_broadcast - Get number of physical broadcast IDs
> @@ -508,6 +471,23 @@ static void lapic_timer_broadcast(const struct cpumask *mask)
>  #endif
>  }
>  
> +
> +/*
> + * The local apic timer can be used for any function which is CPU local.
> + */
> +static struct clock_event_device lapic_clockevent = {
> +	.name		= "lapic",
> +	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT
> +			| CLOCK_EVT_FEAT_C3STOP | CLOCK_EVT_FEAT_DUMMY,
> +	.shift		= 32,
> +	.set_mode	= lapic_timer_setup,
> +	.set_next_event	= lapic_next_event,
> +	.broadcast	= lapic_timer_broadcast,
> +	.rating		= 100,
> +	.irq		= -1,
> +};
> +static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
> +
>  /*
>   * Setup the local APIC timer for this CPU. Copy the initialized values
>   * of the boot CPU and register the clock event in the framework.
> @@ -1209,7 +1189,7 @@ void __cpuinit setup_local_APIC(void)
>  		rdtscll(tsc);
>  
>  	if (disable_apic) {
> -		arch_disable_smp_support();
> +		disable_ioapic_support();
>  		return;
>  	}
>  
> @@ -1448,7 +1428,7 @@ int __init enable_IR(void)
>  void __init enable_IR_x2apic(void)
>  {
>  	unsigned long flags;
> -	struct IO_APIC_route_entry **ioapic_entries = NULL;
> +	struct IO_APIC_route_entry **ioapic_entries;
>  	int ret, x2apic_enabled = 0;
>  	int dmar_table_init_ret;
>  
> @@ -1537,7 +1517,7 @@ static int __init detect_init_APIC(void)
>  }
>  #else
>  
> -static int apic_verify(void)
> +static int __init apic_verify(void)
>  {
>  	u32 features, h, l;
>  
> @@ -1562,7 +1542,7 @@ static int apic_verify(void)
>  	return 0;
>  }
>  
> -int apic_force_enable(void)
> +int __init apic_force_enable(unsigned long addr)
>  {
>  	u32 h, l;
>  
> @@ -1578,7 +1558,7 @@ int apic_force_enable(void)
>  	if (!(l & MSR_IA32_APICBASE_ENABLE)) {
>  		pr_info("Local APIC disabled by BIOS -- reenabling.\n");
>  		l &= ~MSR_IA32_APICBASE_BASE;
> -		l |= MSR_IA32_APICBASE_ENABLE | APIC_DEFAULT_PHYS_BASE;
> +		l |= MSR_IA32_APICBASE_ENABLE | addr;
>  		wrmsr(MSR_IA32_APICBASE, l, h);
>  		enabled_via_apicbase = 1;
>  	}
> @@ -1619,7 +1599,7 @@ static int __init detect_init_APIC(void)
>  				"you can enable it with \"lapic\"\n");
>  			return -1;
>  		}
> -		if (apic_force_enable())
> +		if (apic_force_enable(APIC_DEFAULT_PHYS_BASE))
>  			return -1;
>  	} else {
>  		if (apic_verify())
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index ca9e2a3..8d23e83 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -108,7 +108,10 @@ DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
>  
>  int skip_ioapic_setup;
>  
> -void arch_disable_smp_support(void)
> +/**
> + * disable_ioapic_support() - disables ioapic support at runtime
> + */
> +void disable_ioapic_support(void)
>  {
>  #ifdef CONFIG_PCI
>  	noioapicquirk = 1;
> @@ -120,11 +123,14 @@ void arch_disable_smp_support(void)
>  static int __init parse_noapic(char *str)
>  {
>  	/* disable IO-APIC */
> -	arch_disable_smp_support();
> +	disable_ioapic_support();
>  	return 0;
>  }
>  early_param("noapic", parse_noapic);
>  
> +static int io_apic_setup_irq_pin_once(unsigned int irq, int node,
> +				      struct io_apic_irq_attr *attr);
> +
>  /* Will be called in mpparse/acpi/sfi codes for saving IRQ info */
>  void mp_save_irq(struct mpc_intsrc *m)
>  {
> @@ -818,7 +824,7 @@ static int EISA_ELCR(unsigned int irq)
>  #define default_MCA_trigger(idx)	(1)
>  #define default_MCA_polarity(idx)	default_ISA_polarity(idx)
>  
> -static int MPBIOS_polarity(int idx)
> +static int irq_polarity(int idx)
>  {
>  	int bus = mp_irqs[idx].srcbus;
>  	int polarity;
> @@ -860,7 +866,7 @@ static int MPBIOS_polarity(int idx)
>  	return polarity;
>  }
>  
> -static int MPBIOS_trigger(int idx)
> +static int irq_trigger(int idx)
>  {
>  	int bus = mp_irqs[idx].srcbus;
>  	int trigger;
> @@ -932,16 +938,6 @@ static int MPBIOS_trigger(int idx)
>  	return trigger;
>  }
>  
> -static inline int irq_polarity(int idx)
> -{
> -	return MPBIOS_polarity(idx);
> -}
> -
> -static inline int irq_trigger(int idx)
> -{
> -	return MPBIOS_trigger(idx);
> -}
> -
>  static int pin_2_irq(int idx, int apic, int pin)
>  {
>  	int irq;
> @@ -1220,10 +1216,6 @@ void __setup_vector_irq(int cpu)
>  static struct irq_chip ioapic_chip;
>  static struct irq_chip ir_ioapic_chip;
>  
> -#define IOAPIC_AUTO     -1
> -#define IOAPIC_EDGE     0
> -#define IOAPIC_LEVEL    1
> -
>  #ifdef CONFIG_X86_32
>  static inline int IO_APIC_irq_trigger(int irq)
>  {
> @@ -1385,33 +1377,26 @@ static struct {
>  	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
>  } mp_ioapic_routing[MAX_IO_APICS];
>  
> -static void __init setup_IO_APIC_irqs(void)
> +static bool __init io_apic_pin_not_connected(int idx, int apic_id, int pin)
>  {
> -	int apic_id, pin, idx, irq, notcon = 0;
> -	int node = cpu_to_node(0);
> -	struct irq_cfg *cfg;
> +	if (idx != -1)
> +		return false;
>  
> -	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
> +	apic_printk(APIC_VERBOSE, KERN_DEBUG " apic %d pin %d not connected\n",
> +		    mp_ioapics[apic_id].apicid, pin);
> +	return true;
> +}
> +
> +static void __init __io_apic_setup_irqs(unsigned int apic_id)
> +{
> +	int idx, node = cpu_to_node(0);
> +	struct io_apic_irq_attr attr;
> +	unsigned int pin, irq;
>  
> -	for (apic_id = 0; apic_id < nr_ioapics; apic_id++)
>  	for (pin = 0; pin < nr_ioapic_registers[apic_id]; pin++) {
>  		idx = find_irq_entry(apic_id, pin, mp_INT);
> -		if (idx == -1) {
> -			if (!notcon) {
> -				notcon = 1;
> -				apic_printk(APIC_VERBOSE,
> -					KERN_DEBUG " %d-%d",
> -					mp_ioapics[apic_id].apicid, pin);
> -			} else
> -				apic_printk(APIC_VERBOSE, " %d-%d",
> -					mp_ioapics[apic_id].apicid, pin);
> +		if (io_apic_pin_not_connected(idx, apic_id, pin))
>  			continue;
> -		}
> -		if (notcon) {
> -			apic_printk(APIC_VERBOSE,
> -				" (apicid-pin) not connected\n");
> -			notcon = 0;
> -		}
>  
>  		irq = pin_2_irq(idx, apic_id, pin);
>  
> @@ -1423,25 +1408,24 @@ static void __init setup_IO_APIC_irqs(void)
>  		 * installed and if it returns 1:
>  		 */
>  		if (apic->multi_timer_check &&
> -				apic->multi_timer_check(apic_id, irq))
> +		    apic->multi_timer_check(apic_id, irq))
>  			continue;
>  
> -		cfg = alloc_irq_and_cfg_at(irq, node);
> -		if (!cfg)
> -			continue;
> +		set_io_apic_irq_attr(&attr, apic_id, pin, irq_trigger(idx),
> +				     irq_polarity(idx));
>  
> -		add_pin_to_irq_node(cfg, node, apic_id, pin);
> -		/*
> -		 * don't mark it in pin_programmed, so later acpi could
> -		 * set it correctly when irq < 16
> -		 */
> -		setup_ioapic_irq(apic_id, pin, irq, cfg, irq_trigger(idx),
> -				  irq_polarity(idx));
> +		io_apic_setup_irq_pin(irq, node, &attr);
>  	}
> +}
>  
> -	if (notcon)
> -		apic_printk(APIC_VERBOSE,
> -			" (apicid-pin) not connected\n");
> +static void __init setup_IO_APIC_irqs(void)
> +{
> +	unsigned int apic_id;
> +
> +	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
> +
> +	for (apic_id = 0; apic_id < nr_ioapics; apic_id++)
> +		__io_apic_setup_irqs(apic_id);
>  }
>  
>  /*
> @@ -1452,7 +1436,7 @@ static void __init setup_IO_APIC_irqs(void)
>  void setup_IO_APIC_irq_extra(u32 gsi)
>  {
>  	int apic_id = 0, pin, idx, irq, node = cpu_to_node(0);
> -	struct irq_cfg *cfg;
> +	struct io_apic_irq_attr attr;
>  
>  	/*
>  	 * Convert 'gsi' to 'ioapic.pin'.
> @@ -1472,21 +1456,10 @@ void setup_IO_APIC_irq_extra(u32 gsi)
>  	if (apic_id == 0 || irq < NR_IRQS_LEGACY)
>  		return;
>  
> -	cfg = alloc_irq_and_cfg_at(irq, node);
> -	if (!cfg)
> -		return;
> -
> -	add_pin_to_irq_node(cfg, node, apic_id, pin);
> -
> -	if (test_bit(pin, mp_ioapic_routing[apic_id].pin_programmed)) {
> -		pr_debug("Pin %d-%d already programmed\n",
> -			 mp_ioapics[apic_id].apicid, pin);
> -		return;
> -	}
> -	set_bit(pin, mp_ioapic_routing[apic_id].pin_programmed);
> +	set_io_apic_irq_attr(&attr, apic_id, pin, irq_trigger(idx),
> +			     irq_polarity(idx));
>  
> -	setup_ioapic_irq(apic_id, pin, irq, cfg,
> -			irq_trigger(idx), irq_polarity(idx));
> +	io_apic_setup_irq_pin_once(irq, node, &attr);
>  }
>  
>  /*
> @@ -3605,7 +3578,40 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
>  }
>  #endif /* CONFIG_HT_IRQ */
>  
> -int __init io_apic_get_redir_entries (int ioapic)
> +int
> +io_apic_setup_irq_pin(unsigned int irq, int node, struct io_apic_irq_attr *attr)
> +{
> +	struct irq_cfg *cfg = alloc_irq_and_cfg_at(irq, node);
> +	int ret;
> +
> +	if (!cfg)
> +		return -EINVAL;
> +	ret = __add_pin_to_irq_node(cfg, node, attr->ioapic, attr->ioapic_pin);
> +	if (!ret)
> +		setup_ioapic_irq(attr->ioapic, attr->ioapic_pin, irq, cfg,
> +				 attr->trigger, attr->polarity);
> +	return ret;
> +}
> +
> +static int io_apic_setup_irq_pin_once(unsigned int irq, int node,
> +				      struct io_apic_irq_attr *attr)
> +{
> +	unsigned int id = attr->ioapic, pin = attr->ioapic_pin;
> +	int ret;
> +
> +	/* Avoid redundant programming */
> +	if (test_bit(pin, mp_ioapic_routing[id].pin_programmed)) {
> +		pr_debug("Pin %d-%d already programmed\n",
> +			 mp_ioapics[id].apicid, pin);
> +		return 0;
> +	}
> +	ret = io_apic_setup_irq_pin(irq, node, attr);
> +	if (!ret)
> +		set_bit(pin, mp_ioapic_routing[id].pin_programmed);
> +	return ret;
> +}
> +
> +static int __init io_apic_get_redir_entries(int ioapic)
>  {
>  	union IO_APIC_reg_01	reg_01;
>  	unsigned long flags;
> @@ -3659,96 +3665,24 @@ int __init arch_probe_nr_irqs(void)
>  }
>  #endif
>  
> -static int __io_apic_set_pci_routing(struct device *dev, int irq,
> -				struct io_apic_irq_attr *irq_attr)
> +int io_apic_set_pci_routing(struct device *dev, int irq,
> +			    struct io_apic_irq_attr *irq_attr)
>  {
> -	struct irq_cfg *cfg;
>  	int node;
> -	int ioapic, pin;
> -	int trigger, polarity;
>  
> -	ioapic = irq_attr->ioapic;
>  	if (!IO_APIC_IRQ(irq)) {
>  		apic_printk(APIC_QUIET,KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ 0\n",
> -			ioapic);
> +			    irq_attr->ioapic);
>  		return -EINVAL;
>  	}
>  
> -	if (dev)
> -		node = dev_to_node(dev);
> -	else
> -		node = cpu_to_node(0);
> -
> -	cfg = alloc_irq_and_cfg_at(irq, node);
> -	if (!cfg)
> -		return 0;
> -
> -	pin = irq_attr->ioapic_pin;
> -	trigger = irq_attr->trigger;
> -	polarity = irq_attr->polarity;
> -
> -	/*
> -	 * IRQs < 16 are already in the irq_2_pin[] map
> -	 */
> -	if (irq >= legacy_pic->nr_legacy_irqs) {
> -		if (__add_pin_to_irq_node(cfg, node, ioapic, pin)) {
> -			printk(KERN_INFO "can not add pin %d for irq %d\n",
> -				pin, irq);
> -			return 0;
> -		}
> -	}
> -
> -	setup_ioapic_irq(ioapic, pin, irq, cfg, trigger, polarity);
> +	node = dev ? dev_to_node(dev) : cpu_to_node(0);
>  
> -	return 0;
> +	return io_apic_setup_irq_pin_once(irq, node, irq_attr);
>  }
>  
> -int io_apic_set_pci_routing(struct device *dev, int irq,
> -				struct io_apic_irq_attr *irq_attr)
> -{
> -	int ioapic, pin;
> -	/*
> -	 * Avoid pin reprogramming.  PRTs typically include entries
> -	 * with redundant pin->gsi mappings (but unique PCI devices);
> -	 * we only program the IOAPIC on the first.
> -	 */
> -	ioapic = irq_attr->ioapic;
> -	pin = irq_attr->ioapic_pin;
> -	if (test_bit(pin, mp_ioapic_routing[ioapic].pin_programmed)) {
> -		pr_debug("Pin %d-%d already programmed\n",
> -			 mp_ioapics[ioapic].apicid, pin);
> -		return 0;
> -	}
> -	set_bit(pin, mp_ioapic_routing[ioapic].pin_programmed);
> -
> -	return __io_apic_set_pci_routing(dev, irq, irq_attr);
> -}
> -
> -u8 __init io_apic_unique_id(u8 id)
> -{
>  #ifdef CONFIG_X86_32
> -	if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) &&
> -	    !APIC_XAPIC(apic_version[boot_cpu_physical_apicid]))
> -		return io_apic_get_unique_id(nr_ioapics, id);
> -	else
> -		return id;
> -#else
> -	int i;
> -	DECLARE_BITMAP(used, 256);
> -
> -	bitmap_zero(used, 256);
> -	for (i = 0; i < nr_ioapics; i++) {
> -		struct mpc_ioapic *ia = &mp_ioapics[i];
> -		__set_bit(ia->apicid, used);
> -	}
> -	if (!test_bit(id, used))
> -		return id;
> -	return find_first_zero_bit(used, 256);
> -#endif
> -}
> -
> -#ifdef CONFIG_X86_32
> -int __init io_apic_get_unique_id(int ioapic, int apic_id)
> +static int __init io_apic_get_unique_id(int ioapic, int apic_id)
>  {
>  	union IO_APIC_reg_00 reg_00;
>  	static physid_mask_t apic_id_map = PHYSID_MASK_NONE;
> @@ -3821,9 +3755,33 @@ int __init io_apic_get_unique_id(int ioapic, int apic_id)
>  
>  	return apic_id;
>  }
> +
> +static u8 __init io_apic_unique_id(u8 id)
> +{
> +	if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) &&
> +	    !APIC_XAPIC(apic_version[boot_cpu_physical_apicid]))
> +		return io_apic_get_unique_id(nr_ioapics, id);
> +	else
> +		return id;
> +}
> +#else
> +static u8 __init io_apic_unique_id(u8 id)
> +{
> +	int i;
> +	DECLARE_BITMAP(used, 256);
> +
> +	bitmap_zero(used, 256);
> +	for (i = 0; i < nr_ioapics; i++) {
> +		struct mpc_ioapic *ia = &mp_ioapics[i];
> +		__set_bit(ia->apicid, used);
> +	}
> +	if (!test_bit(id, used))
> +		return id;
> +	return find_first_zero_bit(used, 256);
> +}
>  #endif
>  
> -int __init io_apic_get_version(int ioapic)
> +static int __init io_apic_get_version(int ioapic)
>  {
>  	union IO_APIC_reg_01	reg_01;
>  	unsigned long flags;
> @@ -4026,7 +3984,7 @@ int mp_find_ioapic_pin(int ioapic, u32 gsi)
>  	return gsi - mp_gsi_routing[ioapic].gsi_base;
>  }
>  
> -static int bad_ioapic(unsigned long address)
> +static __init int bad_ioapic(unsigned long address)
>  {
>  	if (nr_ioapics >= MAX_IO_APICS) {
>  		printk(KERN_WARNING "WARING: Max # of I/O APICs (%d) exceeded "
> @@ -4086,20 +4044,15 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
>  /* Enable IOAPIC early just for system timer */
>  void __init pre_init_apic_IRQ0(void)
>  {
> -	struct irq_cfg *cfg;
> +	struct io_apic_irq_attr attr = { 0, 0, 0, 0 };
>  
>  	printk(KERN_INFO "Early APIC setup for system timer0\n");
>  #ifndef CONFIG_SMP
>  	physid_set_mask_of_physid(boot_cpu_physical_apicid,
>  					 &phys_cpu_present_map);
>  #endif
> -	/* Make sure the irq descriptor is set up */
> -	cfg = alloc_irq_and_cfg_at(0, 0);
> -
>  	setup_local_APIC();
>  
> -	add_pin_to_irq_node(cfg, 0, 0, 0);
> +	io_apic_setup_irq_pin(0, 0, &attr);
>  	set_irq_chip_and_handler_name(0, &ioapic_chip, handle_edge_irq, "edge");
> -
> -	setup_ioapic_irq(0, 0, 0, cfg, 0, 0);
>  }
> diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
> new file mode 100644
> index 0000000..7a8cebc
> --- /dev/null
> +++ b/arch/x86/kernel/devicetree.c
> @@ -0,0 +1,441 @@
> +/*
> + * Architecture specific OF callbacks.
> + */
> +#include <linux/bootmem.h>
> +#include <linux/io.h>
> +#include <linux/interrupt.h>
> +#include <linux/list.h>
> +#include <linux/of.h>
> +#include <linux/of_fdt.h>
> +#include <linux/of_address.h>
> +#include <linux/of_platform.h>
> +#include <linux/of_irq.h>
> +#include <linux/slab.h>
> +#include <linux/pci.h>
> +#include <linux/of_pci.h>
> +
> +#include <asm/hpet.h>
> +#include <asm/irq_controller.h>
> +#include <asm/apic.h>
> +#include <asm/pci_x86.h>
> +
> +__initdata u64 initial_dtb;
> +char __initdata cmd_line[COMMAND_LINE_SIZE];
> +static LIST_HEAD(irq_domains);
> +static DEFINE_RAW_SPINLOCK(big_irq_lock);
> +
> +int __initdata of_ioapic;
> +
> +#ifdef CONFIG_X86_IO_APIC
> +static void add_interrupt_host(struct irq_domain *ih)
> +{
> +	unsigned long flags;
> +
> +	raw_spin_lock_irqsave(&big_irq_lock, flags);
> +	list_add(&ih->l, &irq_domains);
> +	raw_spin_unlock_irqrestore(&big_irq_lock, flags);
> +}
> +#endif
> +
> +static struct irq_domain *get_ih_from_node(struct device_node *controller)
> +{
> +	struct irq_domain *ih, *found = NULL;
> +	unsigned long flags;
> +
> +	raw_spin_lock_irqsave(&big_irq_lock, flags);
> +	list_for_each_entry(ih, &irq_domains, l) {
> +		if (ih->controller ==  controller) {
> +			found = ih;
> +			break;
> +		}
> +	}
> +	raw_spin_unlock_irqrestore(&big_irq_lock, flags);
> +	return found;
> +}
> +
> +unsigned int irq_create_of_mapping(struct device_node *controller,
> +				   const u32 *intspec, unsigned int intsize)
> +{
> +	struct irq_domain *ih;
> +	u32 virq, type;
> +	int ret;
> +
> +	ih = get_ih_from_node(controller);
> +	if (!ih)
> +		return 0;
> +	ret = ih->xlate(ih, intspec, intsize, &virq, &type);
> +	if (ret)
> +		return ret;
> +	if (type == IRQ_TYPE_NONE)
> +		return virq;
> +	/* set the mask if it is different from current */
> +	if (type == (irq_to_desc(virq)->status & IRQF_TRIGGER_MASK))
> +		set_irq_type(virq, type);
> +	return virq;
> +}
> +EXPORT_SYMBOL_GPL(irq_create_of_mapping);
> +
> +unsigned long pci_address_to_pio(phys_addr_t address)
> +{
> +	/*
> +	 * The ioport address can be directly used by inX / outX
> +	 */
> +	BUG_ON(address >= (1 << 16));
> +	return (unsigned long)address;
> +}
> +EXPORT_SYMBOL_GPL(pci_address_to_pio);
> +
> +void __init early_init_dt_scan_chosen_arch(unsigned long node)
> +{
> +	BUG();
> +}
> +
> +void __init early_init_dt_add_memory_arch(u64 base, u64 size)
> +{
> +	BUG();
> +}
> +
> +void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
> +{
> +	return __alloc_bootmem(size, align, __pa(MAX_DMA_ADDRESS));
> +}
> +
> +void __init add_dtb(u64 data)
> +{
> +	initial_dtb = data + offsetof(struct setup_data, data);
> +}
> +
> +/*
> + * CE4100 ids. Will be moved to machine_device_initcall() once we have it.
> + */
> +static struct of_device_id __initdata ce4100_ids[] = {
> +	{ .compatible = "intel,ce4100-cp", },
> +	{ .compatible = "isa", },
> +	{ .compatible = "pci", },
> +	{},
> +};
> +
> +static int __init add_bus_probe(void)
> +{
> +	if (!of_have_populated_dt())
> +		return 0;
> +
> +	return of_platform_bus_probe(NULL, ce4100_ids, NULL);
> +}
> +module_init(add_bus_probe);
> +
> +#ifdef CONFIG_PCI
> +static int x86_of_pci_irq_enable(struct pci_dev *dev)
> +{
> +	struct of_irq oirq;
> +	u32 virq;
> +	int ret;
> +	u8 pin;
> +
> +	ret = pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
> +	if (ret)
> +		return ret;
> +	if (!pin)
> +		return 0;
> +
> +	ret = of_irq_map_pci(dev, &oirq);
> +	if (ret)
> +		return ret;
> +
> +	virq = irq_create_of_mapping(oirq.controller, oirq.specifier,
> +			oirq.size);
> +	if (virq == 0)
> +		return -EINVAL;
> +	dev->irq = virq;
> +	return 0;
> +}
> +
> +static void x86_of_pci_irq_disable(struct pci_dev *dev)
> +{
> +}
> +
> +void __cpuinit x86_of_pci_init(void)
> +{
> +	struct device_node *np;
> +
> +	pcibios_enable_irq = x86_of_pci_irq_enable;
> +	pcibios_disable_irq = x86_of_pci_irq_disable;
> +
> +	for_each_node_by_type(np, "pci") {
> +		const void *prop;
> +		struct pci_bus *bus;
> +		unsigned int bus_min;
> +		struct device_node *child;
> +
> +		prop = of_get_property(np, "bus-range", NULL);
> +		if (!prop)
> +			continue;
> +		bus_min = be32_to_cpup(prop);
> +
> +		bus = pci_find_bus(0, bus_min);
> +		if (!bus) {
> +			printk(KERN_ERR "Can't find a node for bus %s.\n",
> +					np->full_name);
> +			continue;
> +		}
> +
> +		if (bus->self)
> +			bus->self->dev.of_node = np;
> +		else
> +			bus->dev.of_node = np;
> +
> +		for_each_child_of_node(np, child) {
> +			struct pci_dev *dev;
> +			u32 devfn;
> +
> +			prop = of_get_property(child, "reg", NULL);
> +			if (!prop)
> +				continue;
> +
> +			devfn = (be32_to_cpup(prop) >> 8) & 0xff;
> +			dev = pci_get_slot(bus, devfn);
> +			if (!dev)
> +				continue;
> +			dev->dev.of_node = child;
> +			pci_dev_put(dev);
> +		}
> +	}
> +}
> +#endif
> +
> +static void __init dtb_setup_hpet(void)
> +{
> +#ifdef CONFIG_HPET_TIMER
> +	struct device_node *dn;
> +	struct resource r;
> +	int ret;
> +
> +	dn = of_find_compatible_node(NULL, NULL, "intel,ce4100-hpet");
> +	if (!dn)
> +		return;
> +	ret = of_address_to_resource(dn, 0, &r);
> +	if (ret) {
> +		WARN_ON(1);
> +		return;
> +	}
> +	hpet_address = r.start;
> +#endif
> +}
> +
> +static void __init dtb_lapic_setup(void)
> +{
> +#ifdef CONFIG_X86_LOCAL_APIC
> +	struct device_node *dn;
> +	struct resource r;
> +	int ret;
> +
> +	dn = of_find_compatible_node(NULL, NULL, "intel,ce4100-lapic");
> +	if (!dn)
> +		return;
> +
> +	ret = of_address_to_resource(dn, 0, &r);
> +	if (WARN_ON(ret))
> +		return;
> +
> +	/* Did the boot loader setup the local APIC ? */
> +	if (!cpu_has_apic) {
> +		if (apic_force_enable(r.start))
> +			return;
> +	}
> +	smp_found_config = 1;
> +	pic_mode = 1;
> +	register_lapic_address(r.start);
> +	generic_processor_info(boot_cpu_physical_apicid,
> +			       GET_APIC_VERSION(apic_read(APIC_LVR)));
> +#endif
> +}
> +
> +#ifdef CONFIG_X86_IO_APIC
> +static unsigned int ioapic_id;
> +
> +static void __init dtb_add_ioapic(struct device_node *dn)
> +{
> +	struct resource r;
> +	int ret;
> +
> +	ret = of_address_to_resource(dn, 0, &r);
> +	if (ret) {
> +		printk(KERN_ERR "Can't obtain address from node %s.\n",
> +				dn->full_name);
> +		return;
> +	}
> +	mp_register_ioapic(++ioapic_id, r.start, gsi_top);
> +}
> +
> +static void __init dtb_ioapic_setup(void)
> +{
> +	struct device_node *dn;
> +
> +	for_each_compatible_node(dn, NULL, "intel,ce4100-ioapic")
> +		dtb_add_ioapic(dn);
> +
> +	if (nr_ioapics) {
> +		of_ioapic = 1;
> +		return;
> +	}
> +	printk(KERN_ERR "Error: No information about IO-APIC in OF.\n");
> +}
> +#else
> +static void __init dtb_ioapic_setup(void) {}
> +#endif
> +
> +static void __init dtb_apic_setup(void)
> +{
> +	dtb_lapic_setup();
> +	dtb_ioapic_setup();
> +}
> +
> +#ifdef CONFIG_OF_FLATTREE
> +static void __init x86_flattree_get_config(void)
> +{
> +	u32 size, map_len;
> +	void *new_dtb;
> +
> +	if (!initial_dtb)
> +		return;
> +
> +	map_len = max(PAGE_SIZE - (initial_dtb & ~PAGE_MASK),
> +			(u64)sizeof(struct boot_param_header));
> +
> +	initial_boot_params = early_memremap(initial_dtb, map_len);
> +	size = be32_to_cpu(initial_boot_params->totalsize);
> +	if (map_len < size) {
> +		early_iounmap(initial_boot_params, map_len);
> +		initial_boot_params = early_memremap(initial_dtb, size);
> +		map_len = size;
> +	}
> +
> +	new_dtb = alloc_bootmem(size);
> +	memcpy(new_dtb, initial_boot_params, size);
> +	early_iounmap(initial_boot_params, map_len);
> +
> +	initial_boot_params = new_dtb;
> +
> +	/* root level address cells */
> +	of_scan_flat_dt(early_init_dt_scan_root, NULL);
> +
> +	unflatten_device_tree();
> +}
> +#else
> +static inline void x86_flattree_get_config(void) { }
> +#endif
> +
> +void __init x86_dtb_init(void)
> +{
> +	x86_flattree_get_config();
> +
> +	if (!of_have_populated_dt())
> +		return;
> +
> +	dtb_setup_hpet();
> +	dtb_apic_setup();
> +}
> +
> +#ifdef CONFIG_X86_IO_APIC
> +
> +struct of_ioapic_type {
> +	u32 out_type;
> +	u32 trigger;
> +	u32 polarity;
> +};
> +
> +static struct of_ioapic_type of_ioapic_type[] =
> +{
> +	{
> +		.out_type	= IRQ_TYPE_EDGE_RISING,
> +		.trigger	= IOAPIC_EDGE,
> +		.polarity	= 1,
> +	},
> +	{
> +		.out_type	= IRQ_TYPE_LEVEL_LOW,
> +		.trigger	= IOAPIC_LEVEL,
> +		.polarity	= 0,
> +	},
> +	{
> +		.out_type	= IRQ_TYPE_LEVEL_HIGH,
> +		.trigger	= IOAPIC_LEVEL,
> +		.polarity	= 1,
> +	},
> +	{
> +		.out_type	= IRQ_TYPE_EDGE_FALLING,
> +		.trigger	= IOAPIC_EDGE,
> +		.polarity	= 0,
> +	},
> +};
> +
> +static int ioapic_xlate(struct irq_domain *id, const u32 *intspec, u32 intsize,
> +			u32 *out_hwirq, u32 *out_type)
> +{
> +	struct io_apic_irq_attr attr;
> +	struct of_ioapic_type *it;
> +	u32 line, idx, type;
> +
> +	if (intsize < 2)
> +		return -EINVAL;
> +
> +	line = *intspec;
> +	idx = (u32) id->priv;
> +	*out_hwirq = line + mp_gsi_routing[idx].gsi_base;
> +
> +	intspec++;
> +	type = *intspec;
> +
> +	if (type >= ARRAY_SIZE(of_ioapic_type))
> +		return -EINVAL;
> +
> +	it = of_ioapic_type + type;
> +	*out_type = it->out_type;
> +
> +	set_io_apic_irq_attr(&attr, idx, line, it->trigger, it->polarity);
> +
> +	return io_apic_setup_irq_pin(*out_hwirq, cpu_to_node(0), &attr);
> +}
> +
> +static void __init ioapic_add_ofnode(struct device_node *np)
> +{
> +	struct resource r;
> +	int i, ret;
> +
> +	ret = of_address_to_resource(np, 0, &r);
> +	if (ret) {
> +		printk(KERN_ERR "Failed to obtain address for %s\n",
> +				np->full_name);
> +		return;
> +	}
> +
> +	for (i = 0; i < nr_ioapics; i++) {
> +		if (r.start == mp_ioapics[i].apicaddr) {
> +			struct irq_domain *id;
> +
> +			id = kzalloc(sizeof(*id), GFP_KERNEL);
> +			BUG_ON(!id);
> +			id->controller = np;
> +			id->xlate = ioapic_xlate;
> +			id->priv = (void *)i;
> +			add_interrupt_host(id);
> +			return;
> +		}
> +	}
> +	printk(KERN_ERR "IOxAPIC at %s is not registered.\n", np->full_name);
> +}
> +
> +void __init x86_add_irq_domains(void)
> +{
> +	struct device_node *dp;
> +
> +	if (!of_have_populated_dt())
> +		return;
> +
> +	for_each_node_with_property(dp, "interrupt-controller") {
> +		if (of_device_is_compatible(dp, "intel,ce4100-ioapic"))
> +			ioapic_add_ofnode(dp);
> +	}
> +}
> +#else
> +void __init x86_add_irq_domains(void) { }
> +#endif
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index 294f26d..5fad626 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -667,21 +667,15 @@ __init void e820_setup_gap(void)
>   * boot_params.e820_map, others are passed via SETUP_E820_EXT node of
>   * linked list of struct setup_data, which is parsed here.
>   */
> -void __init parse_e820_ext(struct setup_data *sdata, unsigned long pa_data)
> +void __init parse_e820_ext(struct setup_data *sdata)
>  {
> -	u32 map_len;
>  	int entries;
>  	struct e820entry *extmap;
>  
>  	entries = sdata->len / sizeof(struct e820entry);
> -	map_len = sdata->len + sizeof(struct setup_data);
> -	if (map_len > PAGE_SIZE)
> -		sdata = early_ioremap(pa_data, map_len);
>  	extmap = (struct e820entry *)(sdata->data);
>  	__append_e820_map(extmap, entries);
>  	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
> -	if (map_len > PAGE_SIZE)
> -		early_iounmap(sdata, map_len);
>  	printk(KERN_INFO "extended physical RAM map:\n");
>  	e820_print_map("extended");
>  }
> diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
> index 767d6c4..d8cc18a 100644
> --- a/arch/x86/kernel/head_32.S
> +++ b/arch/x86/kernel/head_32.S
> @@ -137,7 +137,7 @@ ENTRY(startup_32)
>  	movsl
>  1:
>  
> -#ifdef CONFIG_OLPC_OPENFIRMWARE
> +#ifdef CONFIG_OLPC
>  	/* save OFW's pgdir table for later use when calling into OFW */
>  	movl %cr3, %eax
>  	movl %eax, pa(olpc_ofw_pgd)
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index 387b6a0..7531360 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -276,15 +276,6 @@ void smp_x86_platform_ipi(struct pt_regs *regs)
>  
>  EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
>  
> -#ifdef CONFIG_OF
> -unsigned int irq_create_of_mapping(struct device_node *controller,
> -		const u32 *intspec, unsigned int intsize)
> -{
> -	return intspec[0];
> -}
> -EXPORT_SYMBOL_GPL(irq_create_of_mapping);
> -#endif
> -
>  #ifdef CONFIG_HOTPLUG_CPU
>  /* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
>  void fixup_irqs(void)
> diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
> index c752e97..9f76f89 100644
> --- a/arch/x86/kernel/irqinit.c
> +++ b/arch/x86/kernel/irqinit.c
> @@ -25,6 +25,7 @@
>  #include <asm/setup.h>
>  #include <asm/i8259.h>
>  #include <asm/traps.h>
> +#include <asm/prom.h>
>  
>  /*
>   * ISA PIC or low IO-APIC triggered (INTA-cycle or APIC) interrupts:
> @@ -118,6 +119,12 @@ void __init init_IRQ(void)
>  	int i;
>  
>  	/*
> +	 * We probably need a better place for this, but it works for
> +	 * now ...
> +	 */
> +	x86_add_irq_domains();
> +
> +	/*
>  	 * On cpu 0, Assign IRQ0_VECTOR..IRQ15_VECTOR's to IRQ 0..15.
>  	 * If these IRQ's are handled by legacy interrupt-controllers like PIC,
>  	 * then this configuration will likely be static after the boot. If
> @@ -243,7 +250,7 @@ void __init native_init_IRQ(void)
>  			set_intr_gate(i, interrupt[i-FIRST_EXTERNAL_VECTOR]);
>  	}
>  
> -	if (!acpi_ioapic)
> +	if (!acpi_ioapic && !of_ioapic)
>  		setup_irq(2, &irq2);
>  
>  #ifdef CONFIG_X86_32
> diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
> index 6f39cab..3f2ad26 100644
> --- a/arch/x86/kernel/rtc.c
> +++ b/arch/x86/kernel/rtc.c
> @@ -6,6 +6,7 @@
>  #include <linux/acpi.h>
>  #include <linux/bcd.h>
>  #include <linux/pnp.h>
> +#include <linux/of.h>
>  
>  #include <asm/vsyscall.h>
>  #include <asm/x86_init.h>
> @@ -236,6 +237,8 @@ static __init int add_rtc_cmos(void)
>  		}
>  	}
>  #endif
> +	if (of_have_populated_dt())
> +		return 0;
>  
>  	platform_device_register(&rtc_device);
>  	dev_info(&rtc_device.dev,
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index d3cfe26..b3143bc 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -113,6 +113,7 @@
>  #endif
>  #include <asm/mce.h>
>  #include <asm/alternative.h>
> +#include <asm/prom.h>
>  
>  /*
>   * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
> @@ -429,16 +430,30 @@ static void __init parse_setup_data(void)
>  		return;
>  	pa_data = boot_params.hdr.setup_data;
>  	while (pa_data) {
> -		data = early_memremap(pa_data, PAGE_SIZE);
> +		u32 data_len, map_len;
> +
> +		map_len = max(PAGE_SIZE - (pa_data & ~PAGE_MASK),
> +			      (u64)sizeof(struct setup_data));
> +		data = early_memremap(pa_data, map_len);
> +		data_len = data->len + sizeof(struct setup_data);
> +		if (data_len > map_len) {
> +			early_iounmap(data, map_len);
> +			data = early_memremap(pa_data, data_len);
> +			map_len = data_len;
> +		}
> +
>  		switch (data->type) {
>  		case SETUP_E820_EXT:
> -			parse_e820_ext(data, pa_data);
> +			parse_e820_ext(data);
> +			break;
> +		case SETUP_DTB:
> +			add_dtb(pa_data);
>  			break;
>  		default:
>  			break;
>  		}
>  		pa_data = data->next;
> -		early_iounmap(data, PAGE_SIZE);
> +		early_iounmap(data, map_len);
>  	}
>  }
>  
> @@ -1029,8 +1044,8 @@ void __init setup_arch(char **cmdline_p)
>  	 * Read APIC and some other early information from ACPI tables.
>  	 */
>  	acpi_boot_init();
> -
>  	sfi_init();
> +	x86_dtb_init();
>  
>  	/*
>  	 * get boot-time SMP configuration:
> @@ -1066,6 +1081,8 @@ void __init setup_arch(char **cmdline_p)
>  #endif
>  	x86_init.oem.banner();
>  
> +	x86_init.timers.wallclock_init();
> +
>  	mcheck_init();
>  
>  	local_irq_save(flags);
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 08776a9..09d0172 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -64,6 +64,7 @@
>  #include <asm/mtrr.h>
>  #include <asm/mwait.h>
>  #include <asm/apic.h>
> +#include <asm/io_apic.h>
>  #include <asm/setup.h>
>  #include <asm/uv/uv.h>
>  #include <linux/mc146818rtc.h>
> @@ -945,6 +946,14 @@ int __cpuinit native_cpu_up(unsigned int cpu)
>  	return 0;
>  }
>  
> +/**
> + * arch_disable_smp_support() - disables SMP support for x86 at runtime
> + */
> +void arch_disable_smp_support(void)
> +{
> +	disable_ioapic_support();
> +}
> +
>  /*
>   * Fall back to non SMP mode after errors.
>   *
> @@ -1045,7 +1054,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
>  				"(tell your hw vendor)\n");
>  		}
>  		smpboot_clear_io_apic();
> -		arch_disable_smp_support();
> +		disable_ioapic_support();
>  		return -1;
>  	}
>  
> diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
> index ceb2911..c11514e 100644
> --- a/arch/x86/kernel/x86_init.c
> +++ b/arch/x86/kernel/x86_init.c
> @@ -70,6 +70,7 @@ struct x86_init_ops x86_init __initdata = {
>  		.setup_percpu_clockev	= setup_boot_APIC_clock,
>  		.tsc_pre_init		= x86_init_noop,
>  		.timer_init		= hpet_time_init,
> +		.wallclock_init		= x86_init_noop,
>  	},
>  
>  	.iommu = {
> diff --git a/arch/x86/pci/ce4100.c b/arch/x86/pci/ce4100.c
> index 85b68ef..c63c6d3 100644
> --- a/arch/x86/pci/ce4100.c
> +++ b/arch/x86/pci/ce4100.c
> @@ -254,7 +254,7 @@ int bridge_read(unsigned int devfn, int reg, int len, u32 *value)
>  static int ce4100_conf_read(unsigned int seg, unsigned int bus,
>  			    unsigned int devfn, int reg, int len, u32 *value)
>  {
> -	int i, retval = 1;
> +	int i;
>  
>  	if (bus == 1) {
>  		for (i = 0; i < ARRAY_SIZE(bus1_fixups); i++) {
> diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
> index d2c0d51..68c0dbc 100644
> --- a/arch/x86/platform/ce4100/ce4100.c
> +++ b/arch/x86/platform/ce4100/ce4100.c
> @@ -15,21 +15,19 @@
>  #include <linux/serial_reg.h>
>  #include <linux/serial_8250.h>
>  
> +#include <asm/prom.h>
>  #include <asm/setup.h>
> +#include <asm/i8259.h>
>  #include <asm/io.h>
> +#include <asm/io_apic.h>
>  
>  static int ce4100_i8042_detect(void)
>  {
>  	return 0;
>  }
>  
> -static void __init sdv_find_smp_config(void)
> -{
> -}
> -
>  #ifdef CONFIG_SERIAL_8250
>  
> -
>  static unsigned int mem_serial_in(struct uart_port *p, int offset)
>  {
>  	offset = offset << p->regshift;
> @@ -118,6 +116,15 @@ static void __init sdv_arch_setup(void)
>  	sdv_serial_fixup();
>  }
>  
> +#ifdef CONFIG_X86_IO_APIC
> +static void __cpuinit sdv_pci_init(void)
> +{
> +	x86_of_pci_init();
> +	/* We can't set this earlier, because we need to calibrate the timer */
> +	legacy_pic = &null_legacy_pic;
> +}
> +#endif
> +
>  /*
>   * CE4100 specific x86_init function overrides and early setup
>   * calls.
> @@ -128,5 +135,10 @@ void __init x86_ce4100_early_setup(void)
>  	x86_platform.i8042_detect = ce4100_i8042_detect;
>  	x86_init.resources.probe_roms = x86_init_noop;
>  	x86_init.mpparse.get_smp_config = x86_init_uint_noop;
> -	x86_init.mpparse.find_smp_config = sdv_find_smp_config;
> +	x86_init.mpparse.find_smp_config = x86_init_noop;
> +
> +#ifdef CONFIG_X86_IO_APIC
> +	x86_init.pci.init_irq = sdv_pci_init;
> +	x86_init.mpparse.setup_ioapic_ids = setup_ioapic_ids_from_mpc_nocheck;
> +#endif
>  }
> diff --git a/arch/x86/platform/ce4100/falconfalls.dts b/arch/x86/platform/ce4100/falconfalls.dts
> new file mode 100644
> index 0000000..dc701ea
> --- /dev/null
> +++ b/arch/x86/platform/ce4100/falconfalls.dts
> @@ -0,0 +1,428 @@
> +/*
> + * CE4100 on Falcon Falls
> + *
> + * (c) Copyright 2010 Intel Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; version 2 of the License.
> + */
> +/dts-v1/;
> +/ {
> +	model = "intel,falconfalls";
> +	compatible = "intel,falconfalls";
> +	#address-cells = <1>;
> +	#size-cells = <1>;
> +
> +	cpus {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		cpu@0 {
> +			device_type = "cpu";
> +			compatible = "intel,ce4100";
> +			reg = <0>;
> +			lapic = <&lapic0>;
> +		};
> +	};
> +
> +	soc@0 {
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		compatible = "intel,ce4100-cp";
> +		ranges;
> +
> +		ioapic1: interrupt-controller@fec00000 {
> +			#interrupt-cells = <2>;
> +			compatible = "intel,ce4100-ioapic";
> +			interrupt-controller;
> +			reg = <0xfec00000 0x1000>;
> +		};
> +
> +		timer@fed00000 {
> +			compatible = "intel,ce4100-hpet";
> +			reg = <0xfed00000 0x200>;
> +		};
> +
> +		lapic0: interrupt-controller@fee00000 {
> +			compatible = "intel,ce4100-lapic";
> +			reg = <0xfee00000 0x1000>;
> +		};
> +
> +		pci@3fc {
> +			#address-cells = <3>;
> +			#size-cells = <2>;
> +			compatible = "intel,ce4100-pci", "pci";
> +			device_type = "pci";
> +			bus-range = <0 0>;
> +			ranges = <0x2000000 0 0xbffff000 0xbffff000 0 0x1000
> +				  0x2000000 0 0xdffe0000 0xdffe0000 0 0x1000
> +				  0x0000000 0 0x0	 0x0	    0 0x100>;
> +
> +			/* Secondary IO-APIC */
> +			ioapic2: interrupt-controller@0,1 {
> +				#interrupt-cells = <2>;
> +				compatible = "intel,ce4100-ioapic";
> +				interrupt-controller;
> +				reg = <0x100 0x0 0x0 0x0 0x0>;
> +				assigned-addresses = <0x02000000 0x0 0xbffff000 0x0 0x1000>;
> +			};
> +
> +			pci@1,0 {
> +				#address-cells = <3>;
> +				#size-cells = <2>;
> +				compatible = "intel,ce4100-pci", "pci";
> +				device_type = "pci";
> +				bus-range = <1 1>;
> +				ranges = <0x2000000 0 0xdffe0000 0x2000000 0 0xdffe0000 0 0x1000>;
> +
> +				interrupt-parent = <&ioapic2>;
> +
> +				display@2,0 {
> +					compatible = "pci8086,2e5b.2",
> +						   "pci8086,2e5b",
> +						   "pciclass038000",
> +						   "pciclass0380";
> +
> +					reg = <0x11000 0x0 0x0 0x0 0x0>;
> +					interrupts = <0 1>;
> +				};
> +
> +				multimedia@3,0 {
> +					compatible = "pci8086,2e5c.2",
> +						   "pci8086,2e5c",
> +						   "pciclass048000",
> +						   "pciclass0480";
> +
> +					reg = <0x11800 0x0 0x0 0x0 0x0>;
> +					interrupts = <2 1>;
> +				};
> +
> +				multimedia@4,0 {
> +					compatible = "pci8086,2e5d.2",
> +						   "pci8086,2e5d",
> +						   "pciclass048000",
> +						   "pciclass0480";
> +
> +					reg = <0x12000 0x0 0x0 0x0 0x0>;
> +					interrupts = <4 1>;
> +				};
> +
> +				multimedia@4,1 {
> +					compatible = "pci8086,2e5e.2",
> +						   "pci8086,2e5e",
> +						   "pciclass048000",
> +						   "pciclass0480";
> +
> +					reg = <0x12100 0x0 0x0 0x0 0x0>;
> +					interrupts = <5 1>;
> +				};
> +
> +				sound@6,0 {
> +					compatible = "pci8086,2e5f.2",
> +						   "pci8086,2e5f",
> +						   "pciclass040100",
> +						   "pciclass0401";
> +
> +					reg = <0x13000 0x0 0x0 0x0 0x0>;
> +					interrupts = <6 1>;
> +				};
> +
> +				sound@6,1 {
> +					compatible = "pci8086,2e5f.2",
> +						   "pci8086,2e5f",
> +						   "pciclass040100",
> +						   "pciclass0401";
> +
> +					reg = <0x13100 0x0 0x0 0x0 0x0>;
> +					interrupts = <7 1>;
> +				};
> +
> +				sound@6,2 {
> +					compatible = "pci8086,2e60.2",
> +						   "pci8086,2e60",
> +						   "pciclass040100",
> +						   "pciclass0401";
> +
> +					reg = <0x13200 0x0 0x0 0x0 0x0>;
> +					interrupts = <8 1>;
> +				};
> +
> +				display@8,0 {
> +					compatible = "pci8086,2e61.2",
> +						   "pci8086,2e61",
> +						   "pciclass038000",
> +						   "pciclass0380";
> +
> +					reg = <0x14000 0x0 0x0 0x0 0x0>;
> +					interrupts = <9 1>;
> +				};
> +
> +				display@8,1 {
> +					compatible = "pci8086,2e62.2",
> +						   "pci8086,2e62",
> +						   "pciclass038000",
> +						   "pciclass0380";
> +
> +					reg = <0x14100 0x0 0x0 0x0 0x0>;
> +					interrupts = <10 1>;
> +				};
> +
> +				multimedia@8,2 {
> +					compatible = "pci8086,2e63.2",
> +						   "pci8086,2e63",
> +						   "pciclass048000",
> +						   "pciclass0480";
> +
> +					reg = <0x14200 0x0 0x0 0x0 0x0>;
> +					interrupts = <11 1>;
> +				};
> +
> +				entertainment-encryption@9,0 {
> +					compatible = "pci8086,2e64.2",
> +						   "pci8086,2e64",
> +						   "pciclass101000",
> +						   "pciclass1010";
> +
> +					reg = <0x14800 0x0 0x0 0x0 0x0>;
> +					interrupts = <12 1>;
> +				};
> +
> +				localbus@a,0 {
> +					compatible = "pci8086,2e65.2",
> +						   "pci8086,2e65",
> +						   "pciclassff0000",
> +						   "pciclassff00";
> +
> +					reg = <0x15000 0x0 0x0 0x0 0x0>;
> +				};
> +
> +				serial@b,0 {
> +					compatible = "pci8086,2e66.2",
> +						   "pci8086,2e66",
> +						   "pciclass070003",
> +						   "pciclass0700";
> +
> +					reg = <0x15800 0x0 0x0 0x0 0x0>;
> +					interrupts = <14 1>;
> +				};
> +
> +				gpio@b,1 {
> +					compatible = "pci8086,2e67.2",
> +						   "pci8086,2e67",
> +						   "pciclassff0000",
> +						   "pciclassff00";
> +
> +					#gpio-cells = <2>;
> +					reg = <0x15900 0x0 0x0 0x0 0x0>;
> +					interrupts = <15 1>;
> +					gpio-controller;
> +				};
> +
> +				i2c-controller@b,2 {
> +					#address-cells = <2>;
> +					#size-cells = <1>;
> +					compatible = "pci8086,2e68.2",
> +						   "pci8086,2e68",
> +						   "pciclass,ff0000",
> +						   "pciclass,ff00";
> +
> +					reg = <0x15a00 0x0 0x0 0x0 0x0>;
> +					interrupts = <16 1>;
> +					ranges = <0 0	0x02000000 0 0xdffe0500	0x100
> +						  1 0	0x02000000 0 0xdffe0600	0x100
> +						  2 0	0x02000000 0 0xdffe0700	0x100>;
> +
> +					i2c@0 {
> +						#address-cells = <1>;
> +						#size-cells = <0>;
> +						compatible = "intel,ce4100-i2c-controller";
> +						reg = <0 0 0x100>;
> +					};
> +
> +					i2c@1 {
> +						#address-cells = <1>;
> +						#size-cells = <0>;
> +						compatible = "intel,ce4100-i2c-controller";
> +						reg = <1 0 0x100>;
> +
> +						gpio@26 {
> +							#gpio-cells = <2>;
> +							compatible = "ti,pcf8575";
> +							reg = <0x26>;
> +							gpio-controller;
> +						};
> +					};
> +
> +					i2c@2 {
> +						#address-cells = <1>;
> +						#size-cells = <0>;
> +						compatible = "intel,ce4100-i2c-controller";
> +						reg = <2 0 0x100>;
> +
> +						gpio@26 {
> +							#gpio-cells = <2>;
> +							compatible = "ti,pcf8575";
> +							reg = <0x26>;
> +							gpio-controller;
> +						};
> +					};
> +				};
> +
> +				smard-card@b,3 {
> +					compatible = "pci8086,2e69.2",
> +						   "pci8086,2e69",
> +						   "pciclass070500",
> +						   "pciclass0705";
> +
> +					reg = <0x15b00 0x0 0x0 0x0 0x0>;
> +					interrupts = <15 1>;
> +				};
> +
> +				spi-controller@b,4 {
> +					#address-cells = <1>;
> +					#size-cells = <0>;
> +					compatible =
> +						"pci8086,2e6a.2",
> +						"pci8086,2e6a",
> +						"pciclass,ff0000",
> +						"pciclass,ff00";
> +
> +					reg = <0x15c00 0x0 0x0 0x0 0x0>;
> +					interrupts = <15 1>;
> +
> +					dac@0 {
> +						compatible = "ti,pcm1755";
> +						reg = <0>;
> +						spi-max-frequency = <115200>;
> +					};
> +
> +					dac@1 {
> +						compatible = "ti,pcm1609a";
> +						reg = <1>;
> +						spi-max-frequency = <115200>;
> +					};
> +
> +					eeprom@2 {
> +						compatible = "atmel,at93c46";
> +						reg = <2>;
> +						spi-max-frequency = <115200>;
> +					};
> +				};
> +
> +				multimedia@b,7 {
> +					compatible = "pci8086,2e6d.2",
> +						   "pci8086,2e6d",
> +						   "pciclassff0000",
> +						   "pciclassff00";
> +
> +					reg = <0x15f00 0x0 0x0 0x0 0x0>;
> +				};
> +
> +				ethernet@c,0 {
> +					compatible = "pci8086,2e6e.2",
> +						   "pci8086,2e6e",
> +						   "pciclass020000",
> +						   "pciclass0200";
> +
> +					reg = <0x16000 0x0 0x0 0x0 0x0>;
> +					interrupts = <21 1>;
> +				};
> +
> +				clock@c,1 {
> +					compatible = "pci8086,2e6f.2",
> +						   "pci8086,2e6f",
> +						   "pciclassff0000",
> +						   "pciclassff00";
> +
> +					reg = <0x16100 0x0 0x0 0x0 0x0>;
> +					interrupts = <3 1>;
> +				};
> +
> +				usb@d,0 {
> +					compatible = "pci8086,2e70.2",
> +						   "pci8086,2e70",
> +						   "pciclass0c0320",
> +						   "pciclass0c03";
> +
> +					reg = <0x16800 0x0 0x0 0x0 0x0>;
> +					interrupts = <22 3>;
> +				};
> +
> +				usb@d,1 {
> +					compatible = "pci8086,2e70.2",
> +						   "pci8086,2e70",
> +						   "pciclass0c0320",
> +						   "pciclass0c03";
> +
> +					reg = <0x16900 0x0 0x0 0x0 0x0>;
> +					interrupts = <22 3>;
> +				};
> +
> +				sata@e,0 {
> +					compatible = "pci8086,2e71.0",
> +						   "pci8086,2e71",
> +						   "pciclass010601",
> +						   "pciclass0106";
> +
> +					reg = <0x17000 0x0 0x0 0x0 0x0>;
> +					interrupts = <23 3>;
> +				};
> +
> +				flash@f,0 {
> +					compatible = "pci8086,701.1",
> +						   "pci8086,701",
> +						   "pciclass050100",
> +						   "pciclass0501";
> +
> +					reg = <0x17800 0x0 0x0 0x0 0x0>;
> +					interrupts = <13 1>;
> +				};
> +
> +				entertainment-encryption@10,0 {
> +					compatible = "pci8086,702.1",
> +						   "pci8086,702",
> +						   "pciclass101000",
> +						   "pciclass1010";
> +
> +					reg = <0x18000 0x0 0x0 0x0 0x0>;
> +				};
> +
> +				co-processor@11,0 {
> +					compatible = "pci8086,703.1",
> +						   "pci8086,703",
> +						   "pciclass0b4000",
> +						   "pciclass0b40";
> +
> +					reg = <0x18800 0x0 0x0 0x0 0x0>;
> +					interrupts = <1 1>;
> +				};
> +
> +				multimedia@12,0 {
> +					compatible = "pci8086,704.0",
> +						   "pci8086,704",
> +						   "pciclass048000",
> +						   "pciclass0480";
> +
> +					reg = <0x19000 0x0 0x0 0x0 0x0>;
> +				};
> +			};
> +
> +			isa@1f,0 {
> +				#address-cells = <2>;
> +				#size-cells = <1>;
> +				compatible = "isa";
> +				ranges = <1 0 0 0 0 0x100>;
> +
> +				rtc@70 {
> +					compatible = "intel,ce4100-rtc", "motorola,mc146818";
> +					interrupts = <8 3>;
> +					interrupt-parent = <&ioapic1>;
> +					ctrl-reg = <2>;
> +					freq-reg = <0x26>;
> +					reg = <1 0x70 2>;
> +				};
> +			};
> +		};
> +	};
> +};
> diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
> index ea6529e..5c0207b 100644
> --- a/arch/x86/platform/mrst/mrst.c
> +++ b/arch/x86/platform/mrst/mrst.c
> @@ -31,6 +31,7 @@
>  #include <asm/apic.h>
>  #include <asm/io_apic.h>
>  #include <asm/mrst.h>
> +#include <asm/mrst-vrtc.h>
>  #include <asm/io.h>
>  #include <asm/i8259.h>
>  #include <asm/intel_scu_ipc.h>
> @@ -268,6 +269,7 @@ void __init x86_mrst_early_setup(void)
>  
>  	x86_platform.calibrate_tsc = mrst_calibrate_tsc;
>  	x86_platform.i8042_detect = mrst_i8042_detect;
> +	x86_init.timers.wallclock_init = mrst_rtc_init;
>  	x86_init.pci.init = pci_mrst_init;
>  	x86_init.pci.fixup_irqs = x86_init_noop;
>  
> diff --git a/arch/x86/platform/mrst/vrtc.c b/arch/x86/platform/mrst/vrtc.c
> index 32cd7ed..04cf645 100644
> --- a/arch/x86/platform/mrst/vrtc.c
> +++ b/arch/x86/platform/mrst/vrtc.c
> @@ -100,22 +100,14 @@ int vrtc_set_mmss(unsigned long nowtime)
>  
>  void __init mrst_rtc_init(void)
>  {
> -	unsigned long rtc_paddr;
> -	void __iomem *virt_base;
> +	unsigned long vrtc_paddr = sfi_mrtc_array[0].phys_addr;
>  
>  	sfi_table_parse(SFI_SIG_MRTC, NULL, NULL, sfi_parse_mrtc);
> -	if (!sfi_mrtc_num)
> +	if (!sfi_mrtc_num || !vrtc_paddr)
>  		return;
>  
> -	rtc_paddr = sfi_mrtc_array[0].phys_addr;
> -
> -	/* vRTC's register address may not be page aligned */
> -	set_fixmap_nocache(FIX_LNW_VRTC, rtc_paddr);
> -
> -	virt_base = (void __iomem *)__fix_to_virt(FIX_LNW_VRTC);
> -	virt_base += rtc_paddr & ~PAGE_MASK;
> -	vrtc_virt_base = virt_base;
> -
> +	vrtc_virt_base = (void __iomem *)set_fixmap_offset_nocache(FIX_LNW_VRTC,
> +								vrtc_paddr);
>  	x86_platform.get_wallclock = vrtc_get_time;
>  	x86_platform.set_wallclock = vrtc_set_mmss;
>  }
> diff --git a/arch/x86/platform/olpc/Makefile b/arch/x86/platform/olpc/Makefile
> index e797428..c2a8cab 100644
> --- a/arch/x86/platform/olpc/Makefile
> +++ b/arch/x86/platform/olpc/Makefile
> @@ -1,4 +1,4 @@
>  obj-$(CONFIG_OLPC)		+= olpc.o
>  obj-$(CONFIG_OLPC_XO1)		+= olpc-xo1.o
> -obj-$(CONFIG_OLPC_OPENFIRMWARE)	+= olpc_ofw.o
> -obj-$(CONFIG_OLPC_OPENFIRMWARE_DT)	+= olpc_dt.o
> +obj-$(CONFIG_OLPC)		+= olpc_ofw.o
> +obj-$(CONFIG_OF_PROMTREE)	+= olpc_dt.o
> diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
> index ef3bcb1..c2ef5ce 100644
> --- a/drivers/i2c/busses/i2c-ocores.c
> +++ b/drivers/i2c/busses/i2c-ocores.c
> @@ -330,9 +330,7 @@ static int __devinit ocores_i2c_probe(struct platform_device *pdev)
>  	i2c->adap = ocores_adapter;
>  	i2c_set_adapdata(&i2c->adap, i2c);
>  	i2c->adap.dev.parent = &pdev->dev;
> -#ifdef CONFIG_OF
>  	i2c->adap.dev.of_node = pdev->dev.of_node;
> -#endif
>  
>  	/* add i2c adapter to i2c tree */
>  	ret = i2c_add_adapter(&i2c->adap);
> @@ -390,15 +388,11 @@ static int ocores_i2c_resume(struct platform_device *pdev)
>  #define ocores_i2c_resume	NULL
>  #endif
>  
> -#ifdef CONFIG_OF
>  static struct of_device_id ocores_i2c_match[] = {
> -        {
> -                .compatible = "opencores,i2c-ocores",
> -        },
> -        {},
> +	{ .compatible = "opencores,i2c-ocores", },
> +	{},
>  };
>  MODULE_DEVICE_TABLE(of, ocores_i2c_match);
> -#endif
>  
>  /* work with hotplug and coldplug */
>  MODULE_ALIAS("platform:ocores-i2c");
> @@ -411,9 +405,7 @@ static struct platform_driver ocores_i2c_driver = {
>  	.driver  = {
>  		.owner = THIS_MODULE,
>  		.name = "ocores-i2c",
> -#ifdef CONFIG_OF
> -                .of_match_table = ocores_i2c_match,
> -#endif
> +		.of_match_table = ocores_i2c_match,
>  	},
>  };
>  
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index f0bd5bc..045ba6e 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -537,9 +537,7 @@ i2c_new_device(struct i2c_adapter *adap, struct i2c_board_info const *info)
>  	client->dev.parent = &client->adapter->dev;
>  	client->dev.bus = &i2c_bus_type;
>  	client->dev.type = &i2c_client_type;
> -#ifdef CONFIG_OF
>  	client->dev.of_node = info->of_node;
> -#endif
>  
>  	dev_set_name(&client->dev, "%d-%04x", i2c_adapter_id(adap),
>  		     client->addr);
> diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
> index fd877f6..2f7fc0c 100644
> --- a/drivers/mmc/host/mmc_spi.c
> +++ b/drivers/mmc/host/mmc_spi.c
> @@ -1516,21 +1516,17 @@ static int __devexit mmc_spi_remove(struct spi_device *spi)
>  	return 0;
>  }
>  
> -#if defined(CONFIG_OF)
>  static struct of_device_id mmc_spi_of_match_table[] __devinitdata = {
>  	{ .compatible = "mmc-spi-slot", },
>  	{},
>  };
> -#endif
>  
>  static struct spi_driver mmc_spi_driver = {
>  	.driver = {
>  		.name =		"mmc_spi",
>  		.bus =		&spi_bus_type,
>  		.owner =	THIS_MODULE,
> -#if defined(CONFIG_OF)
>  		.of_match_table = mmc_spi_of_match_table,
> -#endif
>  	},
>  	.probe =	mmc_spi_probe,
>  	.remove =	__devexit_p(mmc_spi_remove),
> diff --git a/drivers/net/ethoc.c b/drivers/net/ethoc.c
> index b79d7e1..db0290f 100644
> --- a/drivers/net/ethoc.c
> +++ b/drivers/net/ethoc.c
> @@ -1163,15 +1163,11 @@ static int ethoc_resume(struct platform_device *pdev)
>  # define ethoc_resume  NULL
>  #endif
>  
> -#ifdef CONFIG_OF
>  static struct of_device_id ethoc_match[] = {
> -	{
> -		.compatible = "opencores,ethoc",
> -	},
> +	{ .compatible = "opencores,ethoc", },
>  	{},
>  };
>  MODULE_DEVICE_TABLE(of, ethoc_match);
> -#endif
>  
>  static struct platform_driver ethoc_driver = {
>  	.probe   = ethoc_probe,
> @@ -1181,9 +1177,7 @@ static struct platform_driver ethoc_driver = {
>  	.driver  = {
>  		.name = "ethoc",
>  		.owner = THIS_MODULE,
> -#ifdef CONFIG_OF
>  		.of_match_table = ethoc_match,
> -#endif
>  	},
>  };
>  
> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> index 3c6e100..d06a637 100644
> --- a/drivers/of/Kconfig
> +++ b/drivers/of/Kconfig
> @@ -69,4 +69,10 @@ config OF_MDIO
>  	help
>  	  OpenFirmware MDIO bus (Ethernet PHY) accessors
>  
> +config OF_PCI
> +	def_tristate PCI
> +	depends on PCI && (PPC || MICROBLAZE || X86)
> +	help
> +	  OpenFirmware PCI bus accessors
> +
>  endmenu # OF
> diff --git a/drivers/of/Makefile b/drivers/of/Makefile
> index 3ab21a0..f7861ed 100644
> --- a/drivers/of/Makefile
> +++ b/drivers/of/Makefile
> @@ -9,3 +9,4 @@ obj-$(CONFIG_OF_I2C)	+= of_i2c.o
>  obj-$(CONFIG_OF_NET)	+= of_net.o
>  obj-$(CONFIG_OF_SPI)	+= of_spi.o
>  obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
> +obj-$(CONFIG_OF_PCI)	+= of_pci.o
> diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
> new file mode 100644
> index 0000000..ac1ec54
> --- /dev/null
> +++ b/drivers/of/of_pci.c
> @@ -0,0 +1,92 @@
> +#include <linux/kernel.h>
> +#include <linux/of_pci.h>
> +#include <linux/of_irq.h>
> +#include <asm/prom.h>
> +
> +/**
> + * of_irq_map_pci - Resolve the interrupt for a PCI device
> + * @pdev:       the device whose interrupt is to be resolved
> + * @out_irq:    structure of_irq filled by this function
> + *
> + * This function resolves the PCI interrupt for a given PCI device. If a
> + * device-node exists for a given pci_dev, it will use normal OF tree
> + * walking. If not, it will implement standard swizzling and walk up the
> + * PCI tree until an device-node is found, at which point it will finish
> + * resolving using the OF tree walking.
> + */
> +int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq)
> +{
> +	struct device_node *dn, *ppnode;
> +	struct pci_dev *ppdev;
> +	u32 lspec;
> +	__be32 lspec_be;
> +	__be32 laddr[3];
> +	u8 pin;
> +	int rc;
> +
> +	/* Check if we have a device node, if yes, fallback to standard
> +	 * device tree parsing
> +	 */
> +	dn = pci_device_to_OF_node(pdev);
> +	if (dn) {
> +		rc = of_irq_map_one(dn, 0, out_irq);
> +		if (!rc)
> +			return rc;
> +	}
> +
> +	/* Ok, we don't, time to have fun. Let's start by building up an
> +	 * interrupt spec.  we assume #interrupt-cells is 1, which is standard
> +	 * for PCI. If you do different, then don't use that routine.
> +	 */
> +	rc = pci_read_config_byte(pdev, PCI_INTERRUPT_PIN, &pin);
> +	if (rc != 0)
> +		return rc;
> +	/* No pin, exit */
> +	if (pin == 0)
> +		return -ENODEV;
> +
> +	/* Now we walk up the PCI tree */
> +	lspec = pin;
> +	for (;;) {
> +		/* Get the pci_dev of our parent */
> +		ppdev = pdev->bus->self;
> +
> +		/* Ouch, it's a host bridge... */
> +		if (ppdev == NULL) {
> +			ppnode = pci_bus_to_OF_node(pdev->bus);
> +
> +			/* No node for host bridge ? give up */
> +			if (ppnode == NULL)
> +				return -EINVAL;
> +		} else {
> +			/* We found a P2P bridge, check if it has a node */
> +			ppnode = pci_device_to_OF_node(ppdev);
> +		}
> +
> +		/* Ok, we have found a parent with a device-node, hand over to
> +		 * the OF parsing code.
> +		 * We build a unit address from the linux device to be used for
> +		 * resolution. Note that we use the linux bus number which may
> +		 * not match your firmware bus numbering.
> +		 * Fortunately, in most cases, interrupt-map-mask doesn't
> +		 * include the bus number as part of the matching.
> +		 * You should still be careful about that though if you intend
> +		 * to rely on this function (you ship  a firmware that doesn't
> +		 * create device nodes for all PCI devices).
> +		 */
> +		if (ppnode)
> +			break;
> +
> +		/* We can only get here if we hit a P2P bridge with no node,
> +		 * let's do standard swizzling and try again
> +		 */
> +		lspec = pci_swizzle_interrupt_pin(pdev, lspec);
> +		pdev = ppdev;
> +	}
> +
> +	lspec_be = cpu_to_be32(lspec);
> +	laddr[0] = cpu_to_be32((pdev->bus->number << 16) | (pdev->devfn << 8));
> +	laddr[1]  = laddr[2] = cpu_to_be32(0);
> +	return of_irq_map_raw(ppnode, &lspec_be, 1, laddr, out_irq);
> +}
> +EXPORT_SYMBOL_GPL(of_irq_map_pci);
> diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
> index c7ff8df..159b95e 100644
> --- a/drivers/rtc/rtc-cmos.c
> +++ b/drivers/rtc/rtc-cmos.c
> @@ -37,6 +37,8 @@
>  #include <linux/mod_devicetable.h>
>  #include <linux/log2.h>
>  #include <linux/pm.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
>  
>  /* this is for "generic access to PC-style RTC" using CMOS_READ/CMOS_WRITE */
>  #include <asm-generic/rtc.h>
> @@ -1123,6 +1125,47 @@ static struct pnp_driver cmos_pnp_driver = {
>  
>  #endif	/* CONFIG_PNP */
>  
> +#ifdef CONFIG_OF
> +static const struct of_device_id of_cmos_match[] = {
> +	{
> +		.compatible = "motorola,mc146818",
> +	},
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, of_cmos_match);
> +
> +static __init void cmos_of_init(struct platform_device *pdev)
> +{
> +	struct device_node *node = pdev->dev.of_node;
> +	struct rtc_time time;
> +	int ret;
> +	const __be32 *val;
> +
> +	if (!node)
> +		return;
> +
> +	val = of_get_property(node, "ctrl-reg", NULL);
> +	if (val)
> +		CMOS_WRITE(be32_to_cpup(val), RTC_CONTROL);
> +
> +	val = of_get_property(node, "freq-reg", NULL);
> +	if (val)
> +		CMOS_WRITE(be32_to_cpup(val), RTC_FREQ_SELECT);
> +
> +	get_rtc_time(&time);
> +	ret = rtc_valid_tm(&time);
> +	if (ret) {
> +		struct rtc_time def_time = {
> +			.tm_year = 1,
> +			.tm_mday = 1,
> +		};
> +		set_rtc_time(&def_time);
> +	}
> +}
> +#else
> +static inline void cmos_of_init(struct platform_device *pdev) {}
> +#define of_cmos_match NULL
> +#endif
>  /*----------------------------------------------------------------*/
>  
>  /* Platform setup should have set up an RTC device, when PNP is
> @@ -1131,6 +1174,7 @@ static struct pnp_driver cmos_pnp_driver = {
>  
>  static int __init cmos_platform_probe(struct platform_device *pdev)
>  {
> +	cmos_of_init(pdev);
>  	cmos_wake_setup(&pdev->dev);
>  	return cmos_do_probe(&pdev->dev,
>  			platform_get_resource(pdev, IORESOURCE_IO, 0),
> @@ -1162,6 +1206,7 @@ static struct platform_driver cmos_platform_driver = {
>  #ifdef CONFIG_PM
>  		.pm		= &cmos_pm_ops,
>  #endif
> +		.of_match_table = of_cmos_match,
>  	}
>  };
>  
> diff --git a/drivers/rtc/rtc-mrst.c b/drivers/rtc/rtc-mrst.c
> index 1db62db..8d2cf60 100644
> --- a/drivers/rtc/rtc-mrst.c
> +++ b/drivers/rtc/rtc-mrst.c
> @@ -62,6 +62,17 @@ static inline int is_intr(u8 rtc_intr)
>  	return rtc_intr & RTC_IRQMASK;
>  }
>  
> +static inline unsigned char vrtc_is_updating(void)
> +{
> +	unsigned char uip;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&rtc_lock, flags);
> +	uip = (vrtc_cmos_read(RTC_FREQ_SELECT) & RTC_UIP);
> +	spin_unlock_irqrestore(&rtc_lock, flags);
> +	return uip;
> +}
> +
>  /*
>   * rtc_time's year contains the increment over 1900, but vRTC's YEAR
>   * register can't be programmed to value larger than 0x64, so vRTC
> @@ -76,7 +87,7 @@ static int mrst_read_time(struct device *dev, struct rtc_time *time)
>  {
>  	unsigned long flags;
>  
> -	if (rtc_is_updating())
> +	if (vrtc_is_updating())
>  		mdelay(20);
>  
>  	spin_lock_irqsave(&rtc_lock, flags);
> diff --git a/drivers/spi/pxa2xx_spi.c b/drivers/spi/pxa2xx_spi.c
> index 9592883..a429b01 100644
> --- a/drivers/spi/pxa2xx_spi.c
> +++ b/drivers/spi/pxa2xx_spi.c
> @@ -1557,9 +1557,7 @@ static int __devinit pxa2xx_spi_probe(struct platform_device *pdev)
>  	drv_data->ssp = ssp;
>  
>  	master->dev.parent = &pdev->dev;
> -#ifdef CONFIG_OF
>  	master->dev.of_node = pdev->dev.of_node;
> -#endif
>  	/* the spi->mode bits understood by this driver: */
>  	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
>  
> diff --git a/drivers/spi/pxa2xx_spi_pci.c b/drivers/spi/pxa2xx_spi_pci.c
> index 19752b0..378e504 100644
> --- a/drivers/spi/pxa2xx_spi_pci.c
> +++ b/drivers/spi/pxa2xx_spi_pci.c
> @@ -89,9 +89,7 @@ static int __devinit ce4100_spi_probe(struct pci_dev *dev,
>  		goto err_nomem;
>  
>  	pdev->dev.parent = &dev->dev;
> -#ifdef CONFIG_OF
>  	pdev->dev.of_node = dev->dev.of_node;
> -#endif
>  	ssp = &spi_info->ssp;
>  	ssp->phys_base = pci_resource_start(dev, 0);
>  	ssp->mmio_base = ioremap(phys_beg, phys_len);
> diff --git a/drivers/spi/xilinx_spi.c b/drivers/spi/xilinx_spi.c
> index 7adaef6..4d2c75d 100644
> --- a/drivers/spi/xilinx_spi.c
> +++ b/drivers/spi/xilinx_spi.c
> @@ -351,14 +351,12 @@ static irqreturn_t xilinx_spi_irq(int irq, void *dev_id)
>  	return IRQ_HANDLED;
>  }
>  
> -#ifdef CONFIG_OF
>  static const struct of_device_id xilinx_spi_of_match[] = {
>  	{ .compatible = "xlnx,xps-spi-2.00.a", },
>  	{ .compatible = "xlnx,xps-spi-2.00.b", },
>  	{}
>  };
>  MODULE_DEVICE_TABLE(of, xilinx_spi_of_match);
> -#endif
>  
>  struct spi_master *xilinx_spi_init(struct device *dev, struct resource *mem,
>  	u32 irq, s16 bus_num, int num_cs, int little_endian, int bits_per_word)
> @@ -394,9 +392,7 @@ struct spi_master *xilinx_spi_init(struct device *dev, struct resource *mem,
>  
>  	master->bus_num = bus_num;
>  	master->num_chipselect = num_cs;
> -#ifdef CONFIG_OF
>  	master->dev.of_node = dev->of_node;
> -#endif
>  
>  	xspi->mem = *mem;
>  	xspi->irq = irq;
> @@ -539,9 +535,7 @@ static struct platform_driver xilinx_spi_driver = {
>  	.driver = {
>  		.name = XILINX_SPI_NAME,
>  		.owner = THIS_MODULE,
> -#ifdef CONFIG_OF
>  		.of_match_table = xilinx_spi_of_match,
> -#endif
>  	},
>  };
>  
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 1bf5cf0..ca5d252 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -128,9 +128,7 @@ struct device_driver {
>  
>  	bool suppress_bind_attrs;	/* disables bind/unbind via sysfs */
>  
> -#if defined(CONFIG_OF)
>  	const struct of_device_id	*of_match_table;
> -#endif
>  
>  	int (*probe) (struct device *dev);
>  	int (*remove) (struct device *dev);
> @@ -441,9 +439,8 @@ struct device {
>  					     override */
>  	/* arch specific additions */
>  	struct dev_archdata	archdata;
> -#ifdef CONFIG_OF
> -	struct device_node	*of_node;
> -#endif
> +
> +	struct device_node	*of_node; /* associated device tree node */
>  
>  	dev_t			devt;	/* dev_t, creates the sysfs "dev" */
>  
> diff --git a/include/linux/i2c.h b/include/linux/i2c.h
> index 903576d..06a8d9c 100644
> --- a/include/linux/i2c.h
> +++ b/include/linux/i2c.h
> @@ -258,9 +258,7 @@ struct i2c_board_info {
>  	unsigned short	addr;
>  	void		*platform_data;
>  	struct dev_archdata	*archdata;
> -#ifdef CONFIG_OF
>  	struct device_node *of_node;
> -#endif
>  	int		irq;
>  };
>  
> diff --git a/include/linux/of.h b/include/linux/of.h
> index cad7cf0..266db1d 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -23,8 +23,6 @@
>  
>  #include <asm/byteorder.h>
>  
> -#ifdef CONFIG_OF
> -
>  typedef u32 phandle;
>  typedef u32 ihandle;
>  
> @@ -65,11 +63,18 @@ struct device_node {
>  #endif
>  };
>  
> +#ifdef CONFIG_OF
> +
>  /* Pointer for first entry in chain of all nodes. */
>  extern struct device_node *allnodes;
>  extern struct device_node *of_chosen;
>  extern rwlock_t devtree_lock;
>  
> +static inline bool of_have_populated_dt(void)
> +{
> +	return allnodes != NULL;
> +}
> +
>  static inline bool of_node_is_root(const struct device_node *node)
>  {
>  	return node && (node->parent == NULL);
> @@ -222,5 +227,12 @@ extern void of_attach_node(struct device_node *);
>  extern void of_detach_node(struct device_node *);
>  #endif
>  
> +#else
> +
> +static inline bool of_have_populated_dt(void)
> +{
> +	return false;
> +}
> +
>  #endif /* CONFIG_OF */
>  #endif /* _LINUX_OF_H */
> diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
> new file mode 100644
> index 0000000..85a27b6
> --- /dev/null
> +++ b/include/linux/of_pci.h
> @@ -0,0 +1,9 @@
> +#ifndef __OF_PCI_H
> +#define __OF_PCI_H
> +
> +#include <linux/pci.h>
> +
> +struct pci_dev;
> +struct of_irq;
> +int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq);
> +#endif
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
