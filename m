Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab2KKFXD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 00:23:03 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60473 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab2KKFW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 00:22:56 -0500
Date: Sun, 11 Nov 2012 06:23:22 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: alsa-devel@alsa-project.org, Markus Grabner <grabner@icg.tugraz.at>,
        Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        line6linux-devel@lists.sourceforge.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALSA: line6: move staging driver to sound/usb/
Message-ID: <20121111052322.GB5795@kroah.com>
References: <1352529892-17610-1-git-send-email-stefanha@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352529892-17610-1-git-send-email-stefanha@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2012 at 07:44:52AM +0100, Stefan Hajnoczi wrote:
> The line6 driver supports devices from the Line6 PODxt, POD HD,
> TonePort, and Variax product families.  This USB sound driver has been
> in staging since 2009 and is ready for wider review and users.
> 
> These devices provide both PCM and MIDI.  Depending on the model the PCM
> supports capture and playback - there may be multiple capture sources.
> MIDI is used to control the device including changing effect or
> amplifier model settings, dumping presets, and changing between patches.
> 
> There are userspace tools and a manual available at:
> 
>   http://www.tanzband-scream.at/line6/
>   http://line6linux.sourceforge.net/
> 
> Cc: Markus Grabner <grabner@icg.tugraz.at>
> Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>

Please fix all of the coding style issues, and the huge number of
undocumented sysfs files before asking to move this out of staging.

thanks,

greg k-h
