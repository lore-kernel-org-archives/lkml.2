Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973Ab1JGMbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 08:31:36 -0400
Received: from 8bytes.org ([88.198.83.132]:59073 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496Ab1JGMbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 08:31:35 -0400
Date: Fri, 7 Oct 2011 14:31:33 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 0/4 v2] PCI: Add support for PASID capability
Message-ID: <20111007123133.GD1512@8bytes.org>
References: <1317131836-11822-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317131836-11822-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 03:57:12PM +0200, Joerg Roedel wrote:
> Hi,
> 
> here is the second version of the patch-set implementing support for the
> PRI and PASID capabilities into the Linux kernel.  These capabilities of
> a PCIe device are tightly coupled with ATS, but not with IOV. So these
> patches start by moving the ATS code into its own file: ats.c.
> 
> Support for the other two capabilities is based on that change.
> 
> Regards,
> 
> 	Joerg
> 
> Changes to v1:
> 
> 	* Improved Kconfig help-text for PASID
> 	* Some editing in the commit messages
> 
> Diffstat:
> 
>  drivers/pci/Kconfig      |   26 +++
>  drivers/pci/Makefile     |    1 +
>  drivers/pci/ats.c        |  438 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/pci/iov.c        |  142 ---------------
>  include/linux/pci-ats.h  |   75 ++++++++
>  include/linux/pci_regs.h |   20 ++
>  6 files changed, 560 insertions(+), 142 deletions(-)

Ping?

