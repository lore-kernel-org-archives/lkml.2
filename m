Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab0K2QMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:12:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34747 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754725Ab0K2QMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:12:22 -0500
Date: Mon, 29 Nov 2010 16:12:31 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Timur Tabi <timur@freescale.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/2] ASoC: Add missing dev_set_drvdata in
 mpc8610_hpcd_probe
Message-ID: <20101129161231.GA5881@opensource.wolfsonmicro.com>
References: <1291013698.19113.1.camel@mola>
 <4CF3BE7C.2000006@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF3BE7C.2000006@freescale.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 08:53:48AM -0600, Timur Tabi wrote:
> Axel Lin wrote:
> > Otherwise, calling dev_get_drvdata in mpc8610_hpcd_remove returns NULL.
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>

> Both patches:

> Acked-by: Timur Tabi <timur@freescale.com>

Applied now.
