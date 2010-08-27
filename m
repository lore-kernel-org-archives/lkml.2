Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab0H0Nmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 09:42:31 -0400
Received: from eazy.amigager.de ([213.239.192.238]:50901 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab0H0Nm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 09:42:28 -0400
Date: Fri, 27 Aug 2010 15:42:26 +0200
From: Tino Keitel <tino.keitel+xorg@tikei.de>
To: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: Re: 2.6.36-rc2 regression: Wrong screen resolution (1024x768
	instead of 1680x1050)
Message-ID: <20100827134226.GA371@eazy.amigager.de>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	intel-gfx@lists.freedesktop.org
References: <20100826073039.GA4567@mac.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100826073039.GA4567@mac.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 09:30:39 +0200, Tino Keitel wrote:
> Hi,
> 
> booting 2.6.36-rc2-git4 (commit
> d4348c678977c7093438bbbf2067c49396ae941b) results in a screen
> resolution of 1024x768 instead of 1680x1050.  It works fine with
> 2.6.35.2.
> 
> The framebuffer console uses the correct resolution, but only uses a
> part of the screen for text output. Xorg output looks distorted.
> 
> Xorg log is attached.
> 
> $ xrandr 
> Screen 0: minimum 320 x 200, current 1024 x 768, maximum 4096 x 4096
> VGA1 disconnected (normal left inverted right x axis y axis)
> DVI1 connected 1024x768+0+0 (normal left inverted right x axis y axis)
> 454mm x 284mm
>    1680x1050      59.9 +
>    1280x1024      60.0  
>    1280x960       60.0  
>    1024x768       60.0* 
>    800x600        60.3  
>    640x480        60.0  
>    720x400        70.1  
> TV1 connected 1024x768+0+0 (normal left inverted right x axis y axis)
> 0mm x 0mm
>    848x480        30.0 +
>    640x480        30.0 +
>    1024x768       30.0* 
>    800x600        30.0  

There is no TV connected, and it was correctly reported as
"disconnected" with 2.6.35.

The Mac mini has some special EDID handling, as the EDID data comes
from the analog EDID channel IIRC, if that helps.

Regards,
Tino
