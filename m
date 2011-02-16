Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab1BPVaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 16:30:04 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60687 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751872Ab1BPVaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 16:30:00 -0500
Date: Wed, 16 Feb 2011 21:29:59 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 3/9] wm8400-codec: use mfd_data instead of driver_data
Message-ID: <20110216212959.GA31254@opensource.wolfsonmicro.com>
References: <1297808729-21110-1-git-send-email-dilinger@queued.net> <1297808729-21110-4-git-send-email-dilinger@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297808729-21110-4-git-send-email-dilinger@queued.net>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 02:25:23PM -0800, Andres Salomon wrote:
> Use mfd_data for passing information from mfd drivers to soc
> clients.  The mfd_cell's driver_data field is being phased out.
> 
> Clients that were using driver_data now access .mfd_data
> via mfd_get_data().
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
