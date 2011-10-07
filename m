Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031Ab1JGOFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 10:05:11 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:57765 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752663Ab1JGOFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 10:05:10 -0400
Date: Fri, 7 Oct 2011 07:05:04 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 0/4 v2] PCI: Add support for PASID capability
Message-ID: <20111007070504.3d5cc1f5@jbarnes-e6510>
In-Reply-To: <20111007123133.GD1512@8bytes.org>
References: <1317131836-11822-1-git-send-email-joerg.roedel@amd.com>
	<20111007123133.GD1512@8bytes.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Oct 2011 14:31:33 +0200
Joerg Roedel <joro@8bytes.org> wrote:

> On Tue, Sep 27, 2011 at 03:57:12PM +0200, Joerg Roedel wrote:
> > Hi,
> > 
> > here is the second version of the patch-set implementing support
> > for the PRI and PASID capabilities into the Linux kernel.  These
> > capabilities of a PCIe device are tightly coupled with ATS, but not
> > with IOV. So these patches start by moving the ATS code into its
> > own file: ats.c.
> > 
> > Support for the other two capabilities is based on that change.

I've got this one queued up, but would definitely appreciate some
reviewed-bys on it.

Thanks,
Jesse
