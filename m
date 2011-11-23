Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab1KWOhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 09:37:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45135 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751896Ab1KWOhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 09:37:39 -0500
Date: Wed, 23 Nov 2011 14:37:37 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marc Vertes <marc.vertes@sigfox.com>
Cc: mad_soft@inbox.ru, wim@iguana.be, w.sang@pengutronix.de,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        HaraldWelte@viatech.com
Subject: Re: [PATCH RFC] watchdog: add a new driver for VIA chipsets
Message-ID: <20111123143737.GD20272@opensource.wolfsonmicro.com>
References: <4ecb84b9.48rmEWqC3D6x18iE%marc.vertes@sigfox.com>
 <20111122112212.GD2734@pengutronix.de>
 <4ecbd66c.8a87vIwdu0Z+quuZ%marc.vertes@sigfox.com>
 <20111122173029.GA14349@pengutronix.de>
 <4ecbe56d.0B7WEVDKkK1s88MJ%marc.vertes@sigfox.com>
 <4ecbf011.dZASXe6D5kH4Uxve%marc.vertes@sigfox.com>
 <20111123121051.GA18320@rainbow>
 <4eccff3f.MbLR7E9v8jus19P8%marc.vertes@sigfox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4eccff3f.MbLR7E9v8jus19P8%marc.vertes@sigfox.com>
X-Cookie: A is for Apple.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 03:12:15PM +0100, Marc Vertes wrote:

> Of course I read the datasheet of the VX855 southbridge prior to
> write this driver. And the VX800 one, the CX700 one. Unfortunately,
> the instructions to start, stop, get and set counters simply
> do not work. The doc is false and/or incomplete. Harald
> already implemented a full version of this driver back in 2009
> (http://git.gnumonks.org/cgi-bin/gitweb.cgi?p=linux-2.6-via.git;a=shortlog;     h=refs/heads/via-wdt),
> but not working. Questions to VIA remain unanswered.

The documentation may actually be accurate - for security/robustness
reasons it's not uncommon for watchdog hardware to have restrictions on
when it can be programmed.  It may be that there's something like that
going on which locks out reprogramming of the block by the time the OS
is up and running, or there may be additional steps required to go into
a secure mode that VIA don't want to disclose.
