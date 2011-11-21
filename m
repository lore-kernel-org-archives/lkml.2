Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab1KUMcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 07:32:06 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38569 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab1KUMcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 07:32:05 -0500
Date: Mon, 21 Nov 2011 12:31:53 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dave Martin <dave.martin@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org
Subject: Re: [PATCH 0/2 REPOST] ARM: amba: Enable module alias
	autogeneration for AMBA drivers
Message-ID: <20111121123153.GQ9581@n2100.arm.linux.org.uk>
References: <1321872510-2562-1-git-send-email-dave.martin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321872510-2562-1-git-send-email-dave.martin@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 10:48:28AM +0000, Dave Martin wrote:
> [This is a partial repost of a series previously posted to alkml.
> 
> This post contains the core changes.  The driver-specific changes
> can be found on alkml.]

As this has been posted a few times to LKML and no one seems to have
interest in it, I'll take the silence as indicating no objections
to the changes in include/linux/mod_devicetable.h and
scripts/mod/file2alias.c.

So I think this is ready for merging.
