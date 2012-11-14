Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab2KNO4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 09:56:44 -0500
Received: from mxout1.idt.com ([157.165.5.25]:43699 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390Ab2KNO4m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 09:56:42 -0500
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Randy Dunlap <rdunlap@infradead.org>, LKML <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Matt Porter <mporter@kernel.crashing.org>
Subject: RE: [PATCH] rapidio: fix kernel-doc warnings
Thread-Topic: [PATCH] rapidio: fix kernel-doc warnings
Thread-Index: AQHNvvBnI7CepLd5R0CPLbe0rfICPpfpcNVQ
Date: Wed, 14 Nov 2012 14:55:56 +0000
Message-ID: <8D983423E7EDF846BB3056827B8CC5D14BC045F7@corpmail1.na.ads.idt.com>
References: <509DC837.6040007@infradead.org>
In-Reply-To: <509DC837.6040007@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.165.140.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 10:21 PM
Randy Dunlap <rdunlap@infradead.org> wrote:
> 
> Fix rapidio kernel-doc warnings:
> 
> Warning(drivers/rapidio/rio.c:415): No description found for parameter
> 'local'
> Warning(drivers/rapidio/rio.c:415): Excess function parameter 'lstart'
> description in 'rio_map_inb_region'
> Warning(include/linux/rio.h:290): No description found for parameter
> 'switches'
> Warning(include/linux/rio.h:290): No description found for parameter
> 'destid_table'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc:	Matt Porter <mporter@kernel.crashing.org>
> Cc:	Alexandre Bounine <alexandre.bounine@idt.com>
> ---
>  drivers/rapidio/rio.c |    2 +-
>  include/linux/rio.h   |    2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> --- lnx-37-rc4.orig/include/linux/rio.h
> +++ lnx-37-rc4/include/linux/rio.h
> @@ -275,9 +275,11 @@ struct rio_id_table {
>   * struct rio_net - RIO network info
>   * @node: Node in global list of RIO networks
>   * @devices: List of devices in this network
> + * @switches: List of switches in this netowrk
>   * @mports: List of master ports accessing this network
>   * @hport: Default port for accessing this network
>   * @id: RIO network ID
> + * @destid_table: destID allocation table
>   */
>  struct rio_net {
>  	struct list_head node;	/* node in list of networks */
> --- lnx-37-rc4.orig/drivers/rapidio/rio.c
> +++ lnx-37-rc4/drivers/rapidio/rio.c
> @@ -401,7 +401,7 @@ EXPORT_SYMBOL_GPL(rio_release_inb_pwrite
>  /**
>   * rio_map_inb_region -- Map inbound memory region.
>   * @mport: Master port.
> - * @lstart: physical address of memory region to be mapped
> + * @local: physical address of memory region to be mapped
>   * @rbase: RIO base address assigned to this window
>   * @size: Size of the memory region
>   * @rflags: Flags for mapping.

Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>

