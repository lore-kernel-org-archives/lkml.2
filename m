Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965620Ab2EOPr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:47:26 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54710 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965596Ab2EOPrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:47:22 -0400
Date: Tue, 15 May 2012 08:47:17 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, linux-doc@vger.kernel.org,
        David Daney <david.daney@cavium.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH 3/3] eeprom/of: Add device tree bindings to at25.
Message-ID: <20120515154717.GA15552@kroah.com>
References: <1336773923-17866-1-git-send-email-ddaney.cavm@gmail.com>
 <1336773923-17866-4-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336773923-17866-4-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 03:05:23PM -0700, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
> 
> We can extract the "pagesize", "size" and "address-width" from the
> device tree so that SPI eeproms can be fully specified in the device
> tree.
> 
> Also add a MODULE_DEVICE_TABLE so the drivers can be automatically bound.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>
> Cc: Michael Hennerich <michael.hennerich@analog.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Axel Lin <axel.lin@gmail.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

