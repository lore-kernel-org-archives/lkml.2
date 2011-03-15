Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab1COACq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 20:02:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59969 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756487Ab1COACn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 20:02:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH 0/2] Re: 2.6.38 regression caused by commit 415e12b
Date: Tue, 15 Mar 2011 01:02:57 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-rc8+; KDE/4.6.0; x86_64; ; )
Cc: linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ozan Caglayan <ozan@pardus.org.tr>
References: <20110228014218.GA11083@xanatos> <201103042132.35711.rjw@sisk.pl> <20110314235634.GC4145@xanatos>
In-Reply-To: <20110314235634.GC4145@xanatos>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201103150102.58126.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 15, 2011, Sarah Sharp wrote:
> On Fri, Mar 04, 2011 at 09:32:35PM +0100, Rafael J. Wysocki wrote:
> > I don't understand why pci_no_msi_support() is called on your system even
> > though pci=nomsi is not in the kernel command line.
> > 
> > Please apply this patch on top of the previous two and send me dmesg.
> 
> Ok, here's the dmesg with your two previous patches applied, plus the
> patch below.  I don't see any stack trace though.

The MSI patch would have worked if that had been the case.

Evidently, the check against ACPI_PCIE_REQ_SUPPORT fails, but I'm not sure why.

Thanks,
Rafael
