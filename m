Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab1CGKtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 05:49:12 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59285 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656Ab1CGKtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 05:49:07 -0500
Subject: Re: [alsa-devel] [PATCH 2/2] ASoC: Constify i2c_device_id table
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Alexander Sverdlin <subaparts@yandex.ru>
Cc: Axel Lin <axel.lin@gmail.com>, alsa-devel@alsa-project.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Liam@alsa-project.org,
        Timur Tabi <timur@freescale.com>
In-Reply-To: <1299223965.27359.2.camel@r60e>
References: <1299223098.20907.1.camel@mola>  <1299223323.20907.4.camel@mola>
	 <1299223965.27359.2.camel@r60e>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 10:49:02 +0000
Message-ID: <1299494942.3377.4.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-04 at 10:32 +0300, Alexander Sverdlin wrote:
> On Fri, 2011-03-04 at 15:22 +0800, Axel Lin wrote:
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > Cc: Alexander Sverdlin <subaparts@yandex.ru>
> > Cc: Timur Tabi <timur@freescale.com>
> > ---
> >  sound/soc/codecs/cs4270.c |    2 +-
> >  sound/soc/codecs/cs4271.c |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> 
> Acked-by: Alexander Sverdlin <subaparts@yandex.ru>
> 

Acked-by: Liam Girdwood <lrg@ti.com>

