Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559Ab0I0PEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 11:04:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46676 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756459Ab0I0PEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 11:04:50 -0400
Date: Mon, 27 Sep 2010 08:05:07 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH 3/3] drivers/power: add missing kfree(wm831x_power) in
 wm831x_power_remove()
Message-ID: <20100927150507.GA13754@opensource.wolfsonmicro.com>
References: <1285571232.31251.1.camel@mola>
 <1285571411.31251.5.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285571411.31251.5.camel@mola>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 03:10:11PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
