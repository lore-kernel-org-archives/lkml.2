Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760456Ab2EIQ7C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:59:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760426Ab2EIQ7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:59:00 -0400
Date: Wed, 9 May 2012 19:58:26 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Myron Stowe <myron.stowe@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        "David Howells <dhowells@redhat.com> Jesper Juhl" <jj@chaosbits.net>
Subject: Re: [PATCH v2 2/2] arch/tile: tilegx PCI root complex support
Message-ID: <20120509165825.GB21461@redhat.com>
References: <201204072316.q37NGv8d019280@farm-0023.internal.tilera.com>
 <201204072319.q37NJgrI019382@farm-0023.internal.tilera.com>
 <alpine.LNX.2.00.1204080126300.4431@swampdragon.chaosbits.net>
 <CAErSpo6_gV1XKJ1jsDSvHo+BEORL_5wLC2YRyVG+OjVNDYbHgw@mail.gmail.com>
 <201204091359.13059.arnd@arndb.de>
 <4F8356C7.60706@tilera.com>
 <201204100914.06168.arnd@arndb.de>
 <201205091555.q49FttvG010396@farm-0027.internal.tilera.com>
 <201205091556.q49Fus3V010419@farm-0027.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205091556.q49Fus3V010419@farm-0027.internal.tilera.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 05:10:17PM -0400, Chris Metcalf wrote:
> +extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);

Please don't put this here. asm-generic/pci_iomap.h already has
a declaration.

-- 
MST
