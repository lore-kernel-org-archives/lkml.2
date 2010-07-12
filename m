Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab0GLM2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 08:28:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60613 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752626Ab0GLM2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 08:28:37 -0400
Date: Mon, 12 Jul 2010 13:28:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        Anuj Aggarwal <anuj.aggarwal@ti.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH v2 1/2] regulator: tps6507x: allow driver to use
 DEFDCDC{2,3}_HIGH register
Message-ID: <20100712122835.GB22701@rakim.wolfsonmicro.main>
References: <1278937448-32404-1-git-send-email-nsekhar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278937448-32404-1-git-send-email-nsekhar@ti.com>
X-Cookie: Yow!  Are we laid back yet?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 05:54:06PM +0530, Sekhar Nori wrote:
> From: Anuj Aggarwal <anuj.aggarwal@ti.com>
> 
> In TPS6507x, depending on the status of DEFDCDC{2,3} pin either
> DEFDCDC{2,3}_LOW or DEFDCDC{2,3}_HIGH register needs to be read or
> programmed to change the output voltage.
> 
> The current driver assumes DEFDCDC{2,3} pins are always tied low
> and thus operates only on DEFDCDC{2,3}_LOW register. This need
> not always be the case (as is found on OMAP-L138 EVM).
> 
> Unfortunately, software cannot read the status of DEFDCDC{2,3} pins.
> So, this information is passed through platform data depending on
> how the board is wired.
> 
> Signed-off-by: Anuj Aggarwal <anuj.aggarwal@ti.com>
> Signed-off-by: Sekhar Nori <nsekhar@ti.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
