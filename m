Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161374Ab1FAMUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 08:20:07 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:53051 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab1FAMUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 08:20:03 -0400
Date: Wed, 1 Jun 2011 14:16:48 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: konrad.wilk@oracle.com, ian.campbell@citrix.com, vgoyal@redhat.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: GSoC 2011 project - Recovery of crashed Linux (running on Xen hypervisor)
Message-ID: <20110601121648.GC29880@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

My name is Daniel Kiper. I was born and live in Poland. I am a PhD
student at Warsaw University of Technology, Faculty of Electronics
and Information Technology.

It is the second opportunity for me to take part in the Google Summer of
Code. In 2010 my proposal, Migration from memory ballooning to memory
hotplug in Xen, was chosen as the GSoC 2010 project. Jeremy Fitzhardinge
from Citrix was the mentor in this project. Additionally, I was strongly
supported by Konrad Rzeszutek Wilk. Currently, the project is very
mature and it will be included in the mainline Linux Kernel shortly.
The participation in GSoC 2010 allowed me to broaden my knowledge in
Xen hypervisor and Linux Kernel. Moreover, I was able to learn something
about open source project maintenance and management. I think this
knowledge can enable me to participate in this years GSoC 2011 more
fruitfully and it can bring in better results for the Xen and Linux
Kernel community.

My GSoC 2011 project is Recovery of crashed Linux and is mentored by
Konrad Rzeszutek Wilk. The work plan is outlined, however, it can change
a bit (maybe more than a bit) while carrying out the project, since some
unexpected things may come out. It looks as follows:

  1) see how the HYPERVISOR_kexec_op hypercall works with PV kernel,
     baremetal kernel and Xen hypervisor,
  2) integrate HYPERVISOR_kexec_op hypercall into mainline Linux Kernel;
     probably it is possible to use some code from
     Xen Linux Kernel Ver. 2.6.18,
  3) create proper "transition" page table initialization,
  4) ACPI/APIC/DMA/PCI/... initialization during reload of PV Linux
     Kernel as dom0; Xen hypervisor is not reloaded,
  5) ACPI/APIC/DMA/PCI/... initialization during reload of PV Linux
     Kernel as dom0 and Xen hypervisor,
  6) block device (PV) initialization (optional),
  7) network device (PV) initialization (optional),
  8) working kexec/kdump implementation on HVM domain
     with PV drivers (optional).

I am going to maintain kexec/kdump support for Xen after finishing the
GSoC 2011. Also, I am looking forward to any comments and questions.

If you are looking for something more about me and my interests please look at:
http://blog.xen.org/index.php/2011/05/27/daniel-kiper-recovery-of-crashed-linux/

Daniel
