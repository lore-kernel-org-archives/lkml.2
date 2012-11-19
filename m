Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab2KSKdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 05:33:36 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60558 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab2KSKdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 05:33:35 -0500
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: <spi-devel-general@lists.sourceforge.net>, linux-omap@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: omap2-mcspi: Fix the redifine warning
References: <1353307349-4611-1-git-send-email-shubhrajyoti@ti.com>
Date: Mon, 19 Nov 2012 11:33:00 +0100
In-Reply-To: <1353307349-4611-1-git-send-email-shubhrajyoti@ti.com>
	(Shubhrajyoti D.'s message of "Mon, 19 Nov 2012 12:12:29 +0530")
Message-ID: <87ehjpnaqr.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Shubhrajyoti" == Shubhrajyoti D <shubhrajyoti@ti.com> writes:

 Shubhrajyoti> Fix the below warning

 Shubhrajyoti> drivers/spi/spi-omap2-mcspi.c:336:34: warning: symbol
 Shubhrajyoti> 'tx' shadows an earlier one
 Shubhrajyoti> drivers/spi/spi-omap2-mcspi.c:327:12: originally declared
 Shubhrajyoti> here

 Shubhrajyoti> So delete the u8 tx as it is assigned and not
 Shubhrajyoti> used(resigned afterwards).

 Shubhrajyoti> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

-- 
Bye, Peter Korsgaard
