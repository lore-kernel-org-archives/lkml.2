Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab1KUOQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 09:16:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53022 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab1KUOQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 09:16:14 -0500
Date: Mon, 21 Nov 2011 14:16:06 +0000
From: Dave Martin <dave.martin@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org
Subject: Re: [PATCH 0/2 REPOST] ARM: amba: Enable module alias autogeneration
 for AMBA drivers
Message-ID: <20111121141606.GA14679@localhost.localdomain>
References: <1321872510-2562-1-git-send-email-dave.martin@linaro.org>
 <20111121123153.GQ9581@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121123153.GQ9581@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 12:31:53PM +0000, Russell King - ARM Linux wrote:
> On Mon, Nov 21, 2011 at 10:48:28AM +0000, Dave Martin wrote:
> > [This is a partial repost of a series previously posted to alkml.
> > 
> > This post contains the core changes.  The driver-specific changes
> > can be found on alkml.]
> 
> As this has been posted a few times to LKML and no one seems to have
> interest in it, I'll take the silence as indicating no objections
> to the changes in include/linux/mod_devicetable.h and
> scripts/mod/file2alias.c.
> 
> So I think this is ready for merging.

Are you willing to take the driver changes through your tree also, or
should I continue to push those separately?

The driver changes are simple and orthogonal; I have Acks on a few of
them, and no disagreements.  The change to each driver is just the
addition of a single MODULE_DEVICE_TABLE() entry in each driver.

The previous full series with all the drivers was posted a while ago
([PATCH 00/16] ARM: amba: Enable module alias autogeneration for AMBA drivers
Message-Id: <1317830707-17517-1-git-send-email-dave.martin@linaro.org>)

Let me know if you need me to repost the series in order to make a
judgement on this.

Thanks
---Dave
