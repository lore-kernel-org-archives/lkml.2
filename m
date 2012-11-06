Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab2KFJAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 04:00:34 -0500
Received: from mail.vyatta.com ([76.74.103.46]:44817 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab2KFJAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 04:00:30 -0500
Date: Tue, 6 Nov 2012 10:00:21 +0100
From: Stephen Hemminger <shemminger@vyatta.com>
To: George Zhang <georgezhang@vmware.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, pv-drivers@vmware.com,
        vm-crosstalk@vmware.com, davem@davemloft.net,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 0/6] VSOCK for Linux upstreaming
Message-ID: <20121106100021.538486e7@s6510.linuxnetplumber.net>
In-Reply-To: <20121105175730.21472.99155.stgit@promb-2n-dhcp175.eng.vmware.com>
References: <20121105175730.21472.99155.stgit@promb-2n-dhcp175.eng.vmware.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Nov 2012 10:00:38 -0800
George Zhang <georgezhang@vmware.com> wrote:

> * * *
> This series of VSOCK linux upstreaming patches include latest udpate from
> VMware.
> 
> Summary of changes:
> 	- Add include/linux/socket.h for AF_VSOCK.
>         - Cleanup some comments.
>         - Cleanup makefiles.
> 
> 
> 
> * * *
> 
> In an effort to improve the out-of-the-box experience with Linux
> kernels for VMware users, VMware is working on readying the Virtual
> Machine Communication Interface (vmw_vmci) and VMCI Sockets (VSOCK)
> (vmw_vsock) kernel modules for inclusion in the Linux kernel. The
> purpose of this post is to acquire feedback on the vmw_vsock kernel
> module. The vmw_vmci kernel module has been presented in an early post.
> 
> 
> * * *
> 
> VMCI Sockets allows virtual machines to communicate with host kernel
> modules and the VMware hypervisors. VMCI Sockets kernel module has
> dependency on VMCI kernel module. User level applications both in
> a virtual machine and on the host can use vmw_vmci through VMCI
> Sockets API which facilitates fast and efficient communication
> between guest virtual machines and their host. A socket
> address family designed to be compatible with UDP and TCP at the
> interface level. Today, VMCI and VMCI Sockets are used by the VMware
> shared folders (HGFS) and various VMware Tools components inside the
> guest for zero-config, network-less access to VMware host services. In
> addition to this, VMware's users are using VMCI Sockets for various
> applications, where network access of the virtual machine is
> restricted or non-existent. Examples of this are VMs communicating
> with device proxies for proprietary hardware running as host
> applications and automated testing of applications running within
> virtual machines.
> 
> The VMware VMCI Sockets are similar to other socket types, like
> Berkeley UNIX socket interface. The VMCI sockets module supports
> both connection-oriented stream sockets like TCP, and connectionless
> datagram sockets like UDP. The VSOCK protocol family is defined as
> "AF_VSOCK" and the socket operations split for SOCK_DGRAM and
> SOCK_STREAM.
> 
> For additional information about the use of VMCI and in particular
> VMCI Sockets, please refer to the VMCI Socket Programming Guide
> available at https://www.vmware.com/support/developer/vmci-sdk/.
> 

This should go to netdev as well since it is a new address family.
