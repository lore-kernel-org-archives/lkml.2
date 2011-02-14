Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab1BNXSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 18:18:51 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12736 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab1BNXSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 18:18:47 -0500
Date: Tue, 15 Feb 2011 00:17:43 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Paul Bolle <pebolle@tiscali.nl>
cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] Fix numbering of KVM API description
 sections
In-Reply-To: <1297724884.1793.38.camel@t41.thuisdomein>
Message-ID: <alpine.LNX.2.00.1102150016040.4530@swampdragon.chaosbits.net>
References: <1297724884.1793.38.camel@t41.thuisdomein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Feb 2011, Paul Bolle wrote:

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  Documentation/kvm/api.txt |   96 ++++++++++++++++++++++----------------------
>  1 files changed, 48 insertions(+), 48 deletions(-)
> 
> diff --git a/Documentation/kvm/api.txt b/Documentation/kvm/api.txt
> index ad85797..9bef4e4 100644
> --- a/Documentation/kvm/api.txt
> +++ b/Documentation/kvm/api.txt
> @@ -166,7 +166,7 @@ Returns: 0 on success, -1 on error
>  
>  This ioctl is obsolete and has been removed.
>  
> -4.6 KVM_CREATE_VCPU
> +4.7 KVM_CREATE_VCPU
>  
>  Capability: basic
>  Architectures: all
> @@ -177,7 +177,7 @@ Returns: vcpu fd on success, -1 on error
>  This API adds a vcpu to a virtual machine.  The vcpu id is a small integer
>  in the range [0, max_vcpus).
>  
> -4.7 KVM_GET_DIRTY_LOG (vm ioctl)
> +4.8 KVM_GET_DIRTY_LOG (vm ioctl)
>  
>  Capability: basic
>  Architectures: x86
> @@ -200,7 +200,7 @@ since the last call to this ioctl.  Bit 0 is the first page in the
>  memory slot.  Ensure the entire structure is cleared to avoid padding
>  issues.
>  
> -4.8 KVM_SET_MEMORY_ALIAS
> +4.9 KVM_SET_MEMORY_ALIAS
>  
>  Capability: basic
>  Architectures: x86
> @@ -210,7 +210,7 @@ Returns: 0 (success), -1 (error)
>  
>  This ioctl is obsolete and has been removed.
>  
> -4.9 KVM_RUN
> +4.10 KVM_RUN
>  
>  Capability: basic
>  Architectures: all
> @@ -226,7 +226,7 @@ obtained by mmap()ing the vcpu fd at offset 0, with the size given by
>  KVM_GET_VCPU_MMAP_SIZE.  The parameter block is formatted as a 'struct
>  kvm_run' (see below).
>  
> -4.10 KVM_GET_REGS
> +4.11 KVM_GET_REGS
>  
>  Capability: basic
>  Architectures: all
> @@ -246,7 +246,7 @@ struct kvm_regs {
>  	__u64 rip, rflags;
>  };
>  
> -4.11 KVM_SET_REGS
> +4.12 KVM_SET_REGS
>  
>  Capability: basic
>  Architectures: all
> @@ -258,7 +258,7 @@ Writes the general purpose registers into the vcpu.
>  
>  See KVM_GET_REGS for the data structure.
>  
> -4.12 KVM_GET_SREGS
> +4.13 KVM_GET_SREGS
>  
>  Capability: basic
>  Architectures: x86
> @@ -283,7 +283,7 @@ interrupt_bitmap is a bitmap of pending external interrupts.  At most
>  one bit may be set.  This interrupt has been acknowledged by the APIC
>  but not yet injected into the cpu core.
>  
> -4.13 KVM_SET_SREGS
> +4.14 KVM_SET_SREGS
>  
>  Capability: basic
>  Architectures: x86
> @@ -294,7 +294,7 @@ Returns: 0 on success, -1 on error
>  Writes special registers into the vcpu.  See KVM_GET_SREGS for the
>  data structures.
>  
> -4.14 KVM_TRANSLATE
> +4.15 KVM_TRANSLATE
>  
>  Capability: basic
>  Architectures: x86
> @@ -317,7 +317,7 @@ struct kvm_translation {
>  	__u8  pad[5];
>  };
>  
> -4.15 KVM_INTERRUPT
> +4.16 KVM_INTERRUPT
>  
>  Capability: basic
>  Architectures: x86, ppc
> @@ -365,7 +365,7 @@ c) KVM_INTERRUPT_SET_LEVEL
>  Note that any value for 'irq' other than the ones stated above is invalid
>  and incurs unexpected behavior.
>  
> -4.16 KVM_DEBUG_GUEST
> +4.17 KVM_DEBUG_GUEST
>  
>  Capability: basic
>  Architectures: none
> @@ -375,7 +375,7 @@ Returns: -1 on error
>  
>  Support for this has been removed.  Use KVM_SET_GUEST_DEBUG instead.
>  
> -4.17 KVM_GET_MSRS
> +4.18 KVM_GET_MSRS
>  
>  Capability: basic
>  Architectures: x86
> @@ -403,7 +403,7 @@ Application code should set the 'nmsrs' member (which indicates the
>  size of the entries array) and the 'index' member of each array entry.
>  kvm will fill in the 'data' member.
>  
> -4.18 KVM_SET_MSRS
> +4.19 KVM_SET_MSRS
>  
>  Capability: basic
>  Architectures: x86
> @@ -418,7 +418,7 @@ Application code should set the 'nmsrs' member (which indicates the
>  size of the entries array), and the 'index' and 'data' members of each
>  array entry.
>  
> -4.19 KVM_SET_CPUID
> +4.20 KVM_SET_CPUID
>  
>  Capability: basic
>  Architectures: x86
> @@ -446,7 +446,7 @@ struct kvm_cpuid {
>  	struct kvm_cpuid_entry entries[0];
>  };
>  
> -4.20 KVM_SET_SIGNAL_MASK
> +4.21 KVM_SET_SIGNAL_MASK
>  
>  Capability: basic
>  Architectures: x86
> @@ -468,7 +468,7 @@ struct kvm_signal_mask {
>  	__u8  sigset[0];
>  };
>  
> -4.21 KVM_GET_FPU
> +4.22 KVM_GET_FPU
>  
>  Capability: basic
>  Architectures: x86
> @@ -493,7 +493,7 @@ struct kvm_fpu {
>  	__u32 pad2;
>  };
>  
> -4.22 KVM_SET_FPU
> +4.23 KVM_SET_FPU
>  
>  Capability: basic
>  Architectures: x86
> @@ -518,7 +518,7 @@ struct kvm_fpu {
>  	__u32 pad2;
>  };
>  
> -4.23 KVM_CREATE_IRQCHIP
> +4.24 KVM_CREATE_IRQCHIP
>  
>  Capability: KVM_CAP_IRQCHIP
>  Architectures: x86, ia64
> @@ -531,7 +531,7 @@ ioapic, a virtual PIC (two PICs, nested), and sets up future vcpus to have a
>  local APIC.  IRQ routing for GSIs 0-15 is set to both PIC and IOAPIC; GSI 16-23
>  only go to the IOAPIC.  On ia64, a IOSAPIC is created.
>  
> -4.24 KVM_IRQ_LINE
> +4.25 KVM_IRQ_LINE
>  
>  Capability: KVM_CAP_IRQCHIP
>  Architectures: x86, ia64
> @@ -552,7 +552,7 @@ struct kvm_irq_level {
>  	__u32 level;           /* 0 or 1 */
>  };
>  
> -4.25 KVM_GET_IRQCHIP
> +4.26 KVM_GET_IRQCHIP
>  
>  Capability: KVM_CAP_IRQCHIP
>  Architectures: x86, ia64
> @@ -573,7 +573,7 @@ struct kvm_irqchip {
>  	} chip;
>  };
>  
> -4.26 KVM_SET_IRQCHIP
> +4.27 KVM_SET_IRQCHIP
>  
>  Capability: KVM_CAP_IRQCHIP
>  Architectures: x86, ia64
> @@ -594,7 +594,7 @@ struct kvm_irqchip {
>  	} chip;
>  };
>  
> -4.27 KVM_XEN_HVM_CONFIG
> +4.28 KVM_XEN_HVM_CONFIG
>  
>  Capability: KVM_CAP_XEN_HVM
>  Architectures: x86
> @@ -618,7 +618,7 @@ struct kvm_xen_hvm_config {
>  	__u8 pad2[30];
>  };
>  
> -4.27 KVM_GET_CLOCK
> +4.29 KVM_GET_CLOCK
>  
>  Capability: KVM_CAP_ADJUST_CLOCK
>  Architectures: x86
> @@ -636,7 +636,7 @@ struct kvm_clock_data {
>  	__u32 pad[9];
>  };
>  
> -4.28 KVM_SET_CLOCK
> +4.30 KVM_SET_CLOCK
>  
>  Capability: KVM_CAP_ADJUST_CLOCK
>  Architectures: x86
> @@ -654,7 +654,7 @@ struct kvm_clock_data {
>  	__u32 pad[9];
>  };
>  
> -4.29 KVM_GET_VCPU_EVENTS
> +4.31 KVM_GET_VCPU_EVENTS
>  
>  Capability: KVM_CAP_VCPU_EVENTS
>  Extended by: KVM_CAP_INTR_SHADOW
> @@ -693,7 +693,7 @@ struct kvm_vcpu_events {
>  KVM_VCPUEVENT_VALID_SHADOW may be set in the flags field to signal that
>  interrupt.shadow contains a valid state. Otherwise, this field is undefined.
>  
> -4.30 KVM_SET_VCPU_EVENTS
> +4.32 KVM_SET_VCPU_EVENTS
>  
>  Capability: KVM_CAP_VCPU_EVENTS
>  Extended by: KVM_CAP_INTR_SHADOW
> @@ -719,7 +719,7 @@ If KVM_CAP_INTR_SHADOW is available, KVM_VCPUEVENT_VALID_SHADOW can be set in
>  the flags field to signal that interrupt.shadow contains a valid state and
>  shall be written into the VCPU.
>  
> -4.32 KVM_GET_DEBUGREGS
> +4.33 KVM_GET_DEBUGREGS
>  
>  Capability: KVM_CAP_DEBUGREGS
>  Architectures: x86
> @@ -737,7 +737,7 @@ struct kvm_debugregs {
>  	__u64 reserved[9];
>  };
>  
> -4.33 KVM_SET_DEBUGREGS
> +4.34 KVM_SET_DEBUGREGS
>  
>  Capability: KVM_CAP_DEBUGREGS
>  Architectures: x86
> @@ -750,7 +750,7 @@ Writes debug registers into the vcpu.
>  See KVM_GET_DEBUGREGS for the data structure. The flags field is unused
>  yet and must be cleared on entry.
>  
> -4.34 KVM_SET_USER_MEMORY_REGION
> +4.35 KVM_SET_USER_MEMORY_REGION
>  
>  Capability: KVM_CAP_USER_MEM
>  Architectures: all
> @@ -796,7 +796,7 @@ It is recommended to use this API instead of the KVM_SET_MEMORY_REGION ioctl.
>  The KVM_SET_MEMORY_REGION does not allow fine grained control over memory
>  allocation and is deprecated.
>  
> -4.35 KVM_SET_TSS_ADDR
> +4.36 KVM_SET_TSS_ADDR
>  
>  Capability: KVM_CAP_SET_TSS_ADDR
>  Architectures: x86
> @@ -814,7 +814,7 @@ This ioctl is required on Intel-based hosts.  This is needed on Intel hardware
>  because of a quirk in the virtualization implementation (see the internals
>  documentation when it pops into existence).
>  
> -4.36 KVM_ENABLE_CAP
> +4.37 KVM_ENABLE_CAP
>  
>  Capability: KVM_CAP_ENABLE_CAP
>  Architectures: ppc
> @@ -849,7 +849,7 @@ function properly, this is the place to put them.
>         __u8  pad[64];
>  };
>  
> -4.37 KVM_GET_MP_STATE
> +4.38 KVM_GET_MP_STATE
>  
>  Capability: KVM_CAP_MP_STATE
>  Architectures: x86, ia64
> @@ -879,7 +879,7 @@ Possible values are:
>  This ioctl is only useful after KVM_CREATE_IRQCHIP.  Without an in-kernel
>  irqchip, the multiprocessing state must be maintained by userspace.
>  
> -4.38 KVM_SET_MP_STATE
> +4.39 KVM_SET_MP_STATE
>  
>  Capability: KVM_CAP_MP_STATE
>  Architectures: x86, ia64
> @@ -893,7 +893,7 @@ arguments.
>  This ioctl is only useful after KVM_CREATE_IRQCHIP.  Without an in-kernel
>  irqchip, the multiprocessing state must be maintained by userspace.
>  
> -4.39 KVM_SET_IDENTITY_MAP_ADDR
> +4.40 KVM_SET_IDENTITY_MAP_ADDR
>  
>  Capability: KVM_CAP_SET_IDENTITY_MAP_ADDR
>  Architectures: x86
> @@ -911,7 +911,7 @@ This ioctl is required on Intel-based hosts.  This is needed on Intel hardware
>  because of a quirk in the virtualization implementation (see the internals
>  documentation when it pops into existence).
>  
> -4.40 KVM_SET_BOOT_CPU_ID
> +4.41 KVM_SET_BOOT_CPU_ID
>  
>  Capability: KVM_CAP_SET_BOOT_CPU_ID
>  Architectures: x86, ia64
> @@ -923,7 +923,7 @@ Define which vcpu is the Bootstrap Processor (BSP).  Values are the same
>  as the vcpu id in KVM_CREATE_VCPU.  If this ioctl is not called, the default
>  is vcpu 0.
>  
> -4.41 KVM_GET_XSAVE
> +4.42 KVM_GET_XSAVE
>  
>  Capability: KVM_CAP_XSAVE
>  Architectures: x86
> @@ -937,7 +937,7 @@ struct kvm_xsave {
>  
>  This ioctl would copy current vcpu's xsave struct to the userspace.
>  
> -4.42 KVM_SET_XSAVE
> +4.43 KVM_SET_XSAVE
>  
>  Capability: KVM_CAP_XSAVE
>  Architectures: x86
> @@ -951,7 +951,7 @@ struct kvm_xsave {
>  
>  This ioctl would copy userspace's xsave struct to the kernel.
>  
> -4.43 KVM_GET_XCRS
> +4.44 KVM_GET_XCRS
>  
>  Capability: KVM_CAP_XCRS
>  Architectures: x86
> @@ -974,7 +974,7 @@ struct kvm_xcrs {
>  
>  This ioctl would copy current vcpu's xcrs to the userspace.
>  
> -4.44 KVM_SET_XCRS
> +4.45 KVM_SET_XCRS
>  
>  Capability: KVM_CAP_XCRS
>  Architectures: x86
> @@ -997,7 +997,7 @@ struct kvm_xcrs {
>  
>  This ioctl would set vcpu's xcr to the value userspace specified.
>  
> -4.45 KVM_GET_SUPPORTED_CPUID
> +4.46 KVM_GET_SUPPORTED_CPUID
>  
>  Capability: KVM_CAP_EXT_CPUID
>  Architectures: x86
> @@ -1062,7 +1062,7 @@ emulate them efficiently. The fields in each entry are defined as follows:
>     eax, ebx, ecx, edx: the values returned by the cpuid instruction for
>           this function/index combination
>  
> -4.46 KVM_PPC_GET_PVINFO
> +4.47 KVM_PPC_GET_PVINFO
>  
>  Capability: KVM_CAP_PPC_GET_PVINFO
>  Architectures: ppc
> @@ -1085,7 +1085,7 @@ of 4 instructions that make up a hypercall.
>  If any additional field gets added to this structure later on, a bit for that
>  additional piece of information will be set in the flags bitmap.
>  
> -4.47 KVM_ASSIGN_PCI_DEVICE
> +4.48 KVM_ASSIGN_PCI_DEVICE
>  
>  Capability: KVM_CAP_DEVICE_ASSIGNMENT
>  Architectures: x86 ia64
> @@ -1113,7 +1113,7 @@ following flags are specified:
>  /* Depends on KVM_CAP_IOMMU */
>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
>  
> -4.48 KVM_DEASSIGN_PCI_DEVICE
> +4.49 KVM_DEASSIGN_PCI_DEVICE
>  
>  Capability: KVM_CAP_DEVICE_DEASSIGNMENT
>  Architectures: x86 ia64
> @@ -1126,7 +1126,7 @@ Ends PCI device assignment, releasing all associated resources.
>  See KVM_CAP_DEVICE_ASSIGNMENT for the data structure. Only assigned_dev_id is
>  used in kvm_assigned_pci_dev to identify the device.
>  
> -4.49 KVM_ASSIGN_DEV_IRQ
> +4.50 KVM_ASSIGN_DEV_IRQ
>  
>  Capability: KVM_CAP_ASSIGN_DEV_IRQ
>  Architectures: x86 ia64
> @@ -1164,7 +1164,7 @@ The following flags are defined:
>  It is not valid to specify multiple types per host or guest IRQ. However, the
>  IRQ type of host and guest can differ or can even be null.
>  
> -4.50 KVM_DEASSIGN_DEV_IRQ
> +4.51 KVM_DEASSIGN_DEV_IRQ
>  
>  Capability: KVM_CAP_ASSIGN_DEV_IRQ
>  Architectures: x86 ia64
> @@ -1178,7 +1178,7 @@ See KVM_ASSIGN_DEV_IRQ for the data structure. The target device is specified
>  by assigned_dev_id, flags must correspond to the IRQ type specified on
>  KVM_ASSIGN_DEV_IRQ. Partial deassignment of host or guest IRQ is allowed.
>  
> -4.51 KVM_SET_GSI_ROUTING
> +4.52 KVM_SET_GSI_ROUTING
>  
>  Capability: KVM_CAP_IRQ_ROUTING
>  Architectures: x86 ia64
> @@ -1226,7 +1226,7 @@ struct kvm_irq_routing_msi {
>  	__u32 pad;
>  };
>  
> -4.52 KVM_ASSIGN_SET_MSIX_NR
> +4.53 KVM_ASSIGN_SET_MSIX_NR
>  
>  Capability: KVM_CAP_DEVICE_MSIX
>  Architectures: x86 ia64
> @@ -1245,7 +1245,7 @@ struct kvm_assigned_msix_nr {
>  
>  #define KVM_MAX_MSIX_PER_DEV		256
>  
> -4.53 KVM_ASSIGN_SET_MSIX_ENTRY
> +4.54 KVM_ASSIGN_SET_MSIX_ENTRY
>  
>  Capability: KVM_CAP_DEVICE_MSIX
>  Architectures: x86 ia64
> 

Yup. Duplicate section numbers for "4.6 KVM_SET_MEMORY_REGION" & "4.6 KVM_CREATE_VCPU".

Reviewed-by: Jesper Juhl <jj@chaosbits.net>

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

