Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab1HBPxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 11:53:45 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:43326 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754080Ab1HBPxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 11:53:39 -0400
Date: Tue, 2 Aug 2011 08:53:27 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jon Mason <mason@myri.com>, Jordan Hargrave <jordan_hargrave@dell.com>
Subject: Re: linux-next: build failure after merge of the pci-current tree
Message-ID: <20110802085327.61325b3c@jbarnes-desktop>
In-Reply-To: <20110802112336.fd2d2b577a2a71892189733b@canb.auug.org.au>
References: <20110802104838.ac7f46b54e8a3fcc4cdd9448@canb.auug.org.au>
	<20110802112336.fd2d2b577a2a71892189733b@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Aug 2011 11:23:36 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Jesse,
> 
> On Tue, 2 Aug 2011 10:48:38 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > After merging the pci-current tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> > 
> > ERROR: ".pcie_bus_configure_settings" [drivers/pci/hotplug/pci_hotplug.ko] undefined!
> > 
> > Caused by commit b03e7495a862 ("PCI: Set PCI-E Max Payload Size on
> > fabric").  Missing EXPORT_SYMBOL?
> > 
> > I have used the pci-current tree from next-20110801 for today.
> 
> And the same for the pci tree (which is identical today).

Jon just sent me the fix and I pushed it out.  Should be fixed now.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
