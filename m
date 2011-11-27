Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab1K0Jwu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 04:52:50 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:54307 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751841Ab1K0Jwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 04:52:49 -0500
X-Sasl-enc: 0VxubcDldYorrSuPzTu5ZOpTavXnk8DurJlssSEWFnzP 1322387566
Date: Sat, 26 Nov 2011 18:04:44 -0800
From: Greg KH <greg@kroah.com>
To: ddaney.cavm@gmail.com
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: Re: [PATCH 8/8] staging: octeon_ethernet: Convert to use device tree.
Message-ID: <20111127020444.GA32071@kroah.com>
References: <1320978124-13042-1-git-send-email-ddaney.cavm@gmail.com>
 <1320978124-13042-9-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320978124-13042-9-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 06:22:04PM -0800, ddaney.cavm@gmail.com wrote:
> From: David Daney <david.daney@cavium.com>
> 
> Get MAC address and PHY connection from the device tree.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

This usually goes through the MIPS tree, so I'll let Ralf take it.

thanks,

greg k-h
