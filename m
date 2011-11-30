Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab1K3VTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 16:19:20 -0500
Received: from usmamail.tilera.com ([206.83.70.75]:8811 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab1K3VTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 16:19:18 -0500
Message-ID: <4ED69DD4.3060403@tilera.com>
Date: Wed, 30 Nov 2011 16:19:16 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Paul Mundt <lethal@linux-sh.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH-RFC 2/2] tile: switch to GENERIC_PCI_IOMAP
References: <cover.1322592494.git.mst@redhat.com> <c5893cb30ae99a7e3c48b3fd209c770cd55c87ef.1322592495.git.mst@redhat.com>
In-Reply-To: <c5893cb30ae99a7e3c48b3fd209c770cd55c87ef.1322592495.git.mst@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2011 1:54 PM, Michael S. Tsirkin wrote:
> tile now has working stubs for ioport_map and ioremap
> such that the generic pci_iomap will DTRT: cast to
> pointer on memory and return NULL and log message on IO map.
>
> Switch it over to GENERIC_PCI_IOMAP.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  arch/tile/Kconfig           |    1 +
>  arch/tile/include/asm/pci.h |    2 +-
>  arch/tile/kernel/pci.c      |   21 ---------------------
>  3 files changed, 2 insertions(+), 22 deletions(-)

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

