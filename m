Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab1LAHd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 02:33:26 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:60369 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab1LAHdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 02:33:25 -0500
Date: Thu, 1 Dec 2011 08:31:38 +0100
From: Harald Welte <laforge@gnumonks.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Convert to DEFINE_PCI_DEVICE_TABLE
Message-ID: <20111201073138.GW16931@prithivi.gnumonks.org>
References: <1322703663.11560.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322703663.11560.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

thanks for your patch. This is trivial, but I'm still sending an Ack:

On Thu, Dec 01, 2011 at 09:41:03AM +0800, Axel Lin wrote:
> Convert static struct pci_device_id *[] to static DEFINE_PCI_DEVICE_TABLE
> tables.
> 
> Cc: Andres Salomon <dilinger@queued.net>
> Cc: Denis Turischev <denis@compulab.co.il>
> Cc: Ben Dooks <ben@simtec.co.uk>
> Cc: Vincent Sanders <vince@simtec.co.uk>
> Cc: Mocean Laboratories <info@mocean-labs.com>
> Cc: Harald Welte <HaraldWelte@viatech.com>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Harald Welte <HaraldWelte@viatech.com>

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
