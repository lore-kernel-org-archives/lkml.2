Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab0HZIrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 04:47:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51724 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753160Ab0HZIrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 04:47:11 -0400
Date: Thu, 26 Aug 2010 09:47:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] ASoC: pxa-ssp: fix a memory leak in pxa_ssp_remove()
Message-ID: <20100826084708.GA26944@rakim.wolfsonmicro.main>
References: <1282726751.5051.4.camel@mola>
 <20100825132212.GB1102@opensource.wolfsonmicro.com>
 <AANLkTinTiOmGo4fpHnOdVPSTH1DuWQeLVvh1ysmwhVM0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinTiOmGo4fpHnOdVPSTH1DuWQeLVvh1ysmwhVM0@mail.gmail.com>
X-Cookie: I'm also against BODY-SURFING!!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 02:10:06PM +0800, Axel Lin wrote:
> I just thought this fix should be applied to 2.6.36.
> And ASoC tree will have this fix after merge 2.6.36.

It's a memory leak on unload for a driver for a device integrated into
an embedded SoC - I'd be astonished if anyone managed to run into it in
production.
