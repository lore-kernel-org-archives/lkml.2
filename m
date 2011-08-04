Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab1HDMiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 08:38:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55254 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753648Ab1HDMiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 08:38:15 -0400
Date: Thu, 4 Aug 2011 21:13:33 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] regulator: tps65023: Fixes i2c configuration issues
Message-ID: <20110804121331.GB9959@opensource.wolfsonmicro.com>
References: <marcus.folkesson@gmail.com>
 <1312457632-27075-1-git-send-email-marcus.folkesson@gmail.com>
 <1312457632-27075-2-git-send-email-marcus.folkesson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312457632-27075-2-git-send-email-marcus.folkesson@gmail.com>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 01:33:49PM +0200, Marcus Folkesson wrote:
> Allow i2c core voltage adjustments by clearing CORE ADJ Allowed bit in CTRL2
> 
> Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
