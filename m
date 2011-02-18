Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab1BRGol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 01:44:41 -0500
Received: from smtp.nokia.com ([147.243.128.26]:48416 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab1BRGoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 01:44:39 -0500
Message-ID: <4D5E153E.308@nokia.com>
Date: Fri, 18 Feb 2011 08:44:14 +0200
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110103 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: ext Andres Salomon <dilinger@queued.net>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 13/29] twl4030: mfd_cell is now implicitly available to
 drivers (v2)
References: <1297998456-7615-1-git-send-email-dilinger@queued.net> <1297998456-7615-14-git-send-email-dilinger@queued.net>
In-Reply-To: <1297998456-7615-14-git-send-email-dilinger@queued.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/11 05:07, ext Andres Salomon wrote:
> The cell's platform_data is now accessed with a helper function;
> change clients to use that, and remove the now-unused data_size.
> 
> v2: add some missing mfd/core.h includes.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>
> ---
>  drivers/input/misc/twl4030-vibra.c |    3 ++-
>  drivers/mfd/twl4030-codec.c        |    2 --
>  sound/soc/codecs/twl4030.c         |    6 ++++--
>  3 files changed, 6 insertions(+), 5 deletions(-)

Acked-by: Peter Ujfalusi <peter.ujfalusi@nokia.com>
