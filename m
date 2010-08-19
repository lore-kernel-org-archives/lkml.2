Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab0HSMgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 08:36:43 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53493 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab0HSMgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 08:36:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rvYXNcPy+8By7tSuC6DUKgewfXfFe0dvEw9cuu5OsW/ykKiIAK2SRS6+FBP2ldffrQ
         wb8X3JX2gKZaAWYFhoysyApfuP2UhRF9CATckk1kn3C/QMwl0gtRiyLo3bPQrpwNeXnC
         OL5p+pF53HaEKIqHC+MBcDb0M4gM9fakQxTiY=
Date: Thu, 19 Aug 2010 16:36:35 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Krogerus Heikki (EXT-Teleca/Helsinki)" 
	<ext-heikki.krogerus@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        dwmw2@infradead.org, felipe.balbi@nokia.com, ameya.palande@nokia.com,
        markus.lehtonen@nokia.com, roger.quadros@nokia.com
Subject: Re: [PATCHv2 1/2] power_supply: add isp1704 charger detection
 driver
Message-ID: <20100819123635.GA12293@oksana.dev.rtsoft.ru>
References: <1282219777-17657-1-git-send-email-ext-heikki.krogerus@nokia.com>
 <1282219777-17657-2-git-send-email-ext-heikki.krogerus@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1282219777-17657-2-git-send-email-ext-heikki.krogerus@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 03:09:36PM +0300, Krogerus Heikki (EXT-Teleca/Helsinki) wrote:
> From: Heikki Krogerus <ext-heikki.krogerus@nokia.com>
> 
> NXP ISP1704 is Battery Charging Specification 1.0 compliant USB
> transceiver. This adds a power supply driver for ISP1704 and
> ISP1707 USB transceivers.
> 
> Signed-off-by: Heikki Krogerus <ext-heikki.krogerus@nokia.com>
> ---

Applied to battery-2.6.git, thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
