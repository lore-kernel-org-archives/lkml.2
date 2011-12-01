Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab1LASox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 13:44:53 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55134 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab1LASot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 13:44:49 -0500
Date: Thu, 1 Dec 2011 10:44:42 -0800
From: Tejun Heo <tj@kernel.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-arch@vger.kernel.org, Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Maxin B. John" <maxin.john@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Paul Mundt <lethal@linux-sh.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] lib/devres.c: allow specifying NO_IOPORT while using
 PCI
Message-ID: <20111201184442.GA13173@google.com>
References: <cover.1322592494.git.mst@redhat.com>
 <201111301404.41544.arnd@arndb.de>
 <20111130143122.GC21413@redhat.com>
 <201111301549.57430.arnd@arndb.de>
 <201112011815.pB1IFGZe004948@farm-0002.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112011815.pB1IFGZe004948@farm-0002.internal.tilera.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 01, 2011 at 12:59:19PM -0500, Chris Metcalf wrote:
> The tile architecture does not support IOPORT, but it does support
> PCI and IOMEM.  We were not specifying NO_IOPORT, though, because it
> was causing a couple of functions (pcim_iomap_regions and pcim_iomap_table)
> that are needed to not get provided.  Moving the #ifdef fixes this
> so that those functions and some related ones are now always provided
> if CONFIG_PCI is true.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

  Acked-by: Tejun Heo <tj@kernel.org>

Please feel free to route the change through tile.  If not, Andrew,
can you please pick this up?

Thanks.

-- 
tejun
