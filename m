Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab1KHNuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 08:50:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58077 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752802Ab1KHNuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 08:50:07 -0500
Date: Tue, 8 Nov 2011 13:50:04 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Afzal Mohammed <afzal@ti.com>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com, sameo@linux.intel.com,
        nsekhar@ti.com, linux-omap@vger.kernel.org
Subject: Re: [PATCH RESEND v2 1/2] mfd: TPS65910: Make usable even if
 interrupt unused
Message-ID: <20111108135004.GL25591@opensource.wolfsonmicro.com>
References: <1320758643-29138-1-git-send-email-afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320758643-29138-1-git-send-email-afzal@ti.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 06:54:03PM +0530, Afzal Mohammed wrote:
> TPS65910 can be used even if interrupt is unused.
> Hence let probe succeed in case interrupt can't be
> configured and let Kernel only to complain about it
> 
> Signed-off-by: Afzal Mohammed <afzal@ti.com>

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
