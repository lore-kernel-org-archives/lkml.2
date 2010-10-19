Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232Ab0JSKoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 06:44:12 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:54688 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab0JSKoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:44:10 -0400
X-IronPort-AV: E=Sophos;i="4.57,349,1283731200"; 
   d="scan'208";a="2408966"
Date: Tue, 19 Oct 2010 11:43:44 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Qing He <qing.he@intel.com>, Yunhong Jiang <yunhong.jiang@intel.com>
Subject: Re: [PATCH v3 03/10] xen: remap MSIs into pirqs when running as
 initial domain
In-Reply-To: <20101018154603.GC27373@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1010191143320.2423@kaball-desktop>
References: <alpine.DEB.2.00.1010121043030.2422@kaball-desktop> <1286901770-8612-3-git-send-email-Stefano.Stabellini@eu.citrix.com> <20101018154603.GC27373@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010, Konrad Rzeszutek Wilk wrote:
> > +int xen_create_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int type)
> > +{
> > +	int irq = 0;
> 
> Lets make the default one -1, as that is the value we
> are checking for errors later on.

good idea
