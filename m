Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435Ab1KWFMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 00:12:49 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64348 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab1KWFMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 00:12:48 -0500
Date: Wed, 23 Nov 2011 07:12:35 +0200
From: Mika Westerberg <mika.westerberg@iki.fi>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "rmallon@gmail.com" <rmallon@gmail.com>,
        Rafal Prylowski <prylowski@metasoft.pl>
Subject: Re: [PATCH 2/2] dma/ep93xx_dma: prevent ep93xx_dma_tasklet() to
 access empty list
Message-ID: <20111123051235.GA2705@mwesterb-mobl.ger.corp.intel.com>
References: <19bcd0ee953116fd71bc1c705636c5fec80608cb.1321990466.git.mika.westerberg@iki.fi>
 <707c0a5c61bd597ceed3871fc3528f687ac0fcff.1321990466.git.mika.westerberg@iki.fi>
 <ADE657CA350FB648AAC2C43247A983F001F3E96DA6B7@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F001F3E96DA6B7@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 02:26:52PM -0600, H Hartley Sweeten wrote:
> 
> I still don't like the BUG_ON here.  Is it even possible to get here with
> an empty list now that your catching it in the tasklet?

It's there just to make sure that we don't corrupt any memory if the list is
empty because of some other, yet unknown, bug.

> 
> But, ep93xx_dma_set_active() also has a BUG_ON test so...
> 
> Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Thanks.
