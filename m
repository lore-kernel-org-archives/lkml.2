Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab2DOXMd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 19:12:33 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:28450 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab2DOXMc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 19:12:32 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Myron Stowe <myron.stowe@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        David Howells <dhowells@redhat.com>
Subject: RE: [PATCH 3/3] arch/tile: tilegx PCI root complex support
Thread-Topic: [PATCH 3/3] arch/tile: tilegx PCI root complex support
Thread-Index: AQHNFq02w7CnYh4xbECCSXNoaIFxhpacjEcM
Date: Sun, 15 Apr 2012 23:09:32 +0000
Message-ID: <9D6CA7A63751804FADD8B075304A6858109A6E1A@USMAExch1.tad.internal.tilera.com>
References: <201204072316.q37NGv8d019280@farm-0023.internal.tilera.com>
 <201204072319.q37NJlNp019384@farm-0023.internal.tilera.com>,<CAErSpo6_gV1XKJ1jsDSvHo+BEORL_5wLC2YRyVG+OjVNDYbHgw@mail.gmail.com>
In-Reply-To: <CAErSpo6_gV1XKJ1jsDSvHo+BEORL_5wLC2YRyVG+OjVNDYbHgw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> Can this be done with the generic pcie_bus_configure_settings() or is
> there something tilegx-specific about this?
> If at all possible, you should use pci_scan_root_bus() here instead,
> so you can tell PCI what the host bridge apertures are.

I've been exchanging email with the author of this driver during the week (he's based out of the California office, and I'm in Massachusetts) and the two suggestions quoted above still need further investigation before we can get back to you.  I'm out next week for spring school break so it won't be until the following week that I'll put out a v2 of this patch.  The other comments (not quoted) we've already incorporated into the driver.

So thanks a lot for your feedback!

Chris Metcalf
Tilera Corp.