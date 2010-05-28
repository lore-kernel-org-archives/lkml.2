Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab0E1XiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 19:38:21 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31975 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab0E1XiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 19:38:17 -0400
Date: Fri, 28 May 2010 16:36:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Tom Lyon" <pugs@cisco.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       joro@8bytes.org, hjk@linutronix.de, mst@redhat.com, avi@redhat.com,
       gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-Id: <20100528163643.44b2f9c3.randy.dunlap@oracle.com>
In-Reply-To: <4c004cba.Z/2Hpd7reetFaFC5%pugs@cisco.com>
References: <4c004cba.Z/2Hpd7reetFaFC5%pugs@cisco.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4C0053CE.0115:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Fri, 28 May 2010 16:07:38 -0700 Tom Lyon wrote:

Missing diffstat -p1 -w 70:

 Documentation/vfio.txt         |  176 ++++++++
 MAINTAINERS                    |    7 
 drivers/Kconfig                |    2 
 drivers/Makefile               |    1 
 drivers/vfio/Kconfig           |    9 
 drivers/vfio/Makefile          |    5 
 drivers/vfio/vfio_dma.c        |  372 ++++++++++++++++++
 drivers/vfio/vfio_intrs.c      |  189 +++++++++
 drivers/vfio/vfio_main.c       |  627 +++++++++++++++++++++++++++++++
 drivers/vfio/vfio_pci_config.c |  554 +++++++++++++++++++++++++++
 drivers/vfio/vfio_rdwr.c       |  147 +++++++
 drivers/vfio/vfio_sysfs.c      |  153 +++++++
 include/linux/vfio.h           |  193 +++++++++
 13 files changed, 2435 insertions(+)


which shows that the patch is missing an update to
Documentation/ioctl/ioctl-number.txt for ioctl code ';'.  Please add that.


> diff -uprN linux-2.6.34/drivers/vfio/Kconfig vfio-linux-2.6.34/drivers/vfio/Kconfig
> --- linux-2.6.34/drivers/vfio/Kconfig	1969-12-31 16:00:00.000000000 -0800
> +++ vfio-linux-2.6.34/drivers/vfio/Kconfig	2010-05-27 17:07:25.000000000 -0700
> @@ -0,0 +1,9 @@
> +menuconfig VFIO
> +	tristate "Non-Priv User Space PCI drivers"

	          Non-privileged

> +	depends on PCI
> +	help
> +	  Driver to allow advanced user space drivers for PCI, PCI-X,
> +	  and PCIe devices.  Requires IOMMU to allow non-privilged

	                                             non-privileged

> +	  processes to directly control the PCI devices.
> +
> +	  If you don't know what to do here, say N.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
