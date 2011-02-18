Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab1BRDvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:51:24 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47099 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751821Ab1BRDvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:51:21 -0500
Date: Thu, 17 Feb 2011 19:51:34 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 20/29] wm8400-codec: use mfd_data instead of
 driver_data (v2)
Message-ID: <20110218035133.GA6069@opensource.wolfsonmicro.com>
References: <1297998456-7615-1-git-send-email-dilinger@queued.net>
 <1297998456-7615-21-git-send-email-dilinger@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297998456-7615-21-git-send-email-dilinger@queued.net>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 07:07:27PM -0800, Andres Salomon wrote:
> Use mfd_data for passing information from mfd drivers to soc
> clients.  The mfd_cell's driver_data field is being phased out.
> 
> Clients that were using driver_data now access .mfd_data
> via mfd_get_data().
> 
> v2: add some missing mfd/core.h includes.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
