Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab1BPV7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 16:59:31 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52729 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab1BPV73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 16:59:29 -0500
Date: Wed, 16 Feb 2011 21:59:23 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [alsa-devel] [PATCH 2/9] davinci_voicecodec: use mfd_data
	instead of driver_data
Message-ID: <20110216215923.GB30245@sirena.org.uk>
References: <1297808729-21110-1-git-send-email-dilinger@queued.net> <1297808729-21110-3-git-send-email-dilinger@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297808729-21110-3-git-send-email-dilinger@queued.net>
X-Cookie: All true wisdom is found on T-shirts.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 02:25:22PM -0800, Andres Salomon wrote:
> Use mfd_data for passing information from mfd drivers to soc
> clients.  The mfd_cell's driver_data field is being phased out.
> 
> Clients that were using driver_data now access .mfd_data
> via mfd_get_data().
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
