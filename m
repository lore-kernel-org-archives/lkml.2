Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab1AEX7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:59:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48547 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650Ab1AEX7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:59:21 -0500
Date: Wed, 5 Jan 2011 15:56:21 -0800
From: Greg KH <gregkh@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Sergej Pupykin <ml@sergej.pp.ru>, Alex Deucher <alexdeucher@gmail.com>,
        Dave Airlie <airlied@redhat.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [06/49] drm/kms: remove spaces from connector
 names (v2)
Message-ID: <20110105235621.GA22850@suse.de>
References: <20110105230323.978508482@clark.site>
 <1294271346.3044.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294271346.3044.2.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 11:49:05PM +0000, Ben Hutchings wrote:
> On Wed, 2011-01-05 at 15:00 -0800, Greg KH wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Alex Deucher <alexdeucher@gmail.com>
> > 
> > commit e76116ca9671e2e5239054a40303b94feab585ad upstream.
> > 
> > Grub doesn't parse spaces in parameters correctly, so
> > this makes it impossible to force video= parameters
> > for kms on the grub kernel command line.
> > 
> > v2: shorten the names to make them easier to type.
> [...]
> > --- a/drivers/gpu/drm/drm_crtc.c
> > +++ b/drivers/gpu/drm/drm_crtc.c
> > @@ -144,10 +144,10 @@ static struct drm_conn_prop_enum_list dr
> >  	{ DRM_MODE_CONNECTOR_SVIDEO, "SVIDEO", 0 },
> >  	{ DRM_MODE_CONNECTOR_LVDS, "LVDS", 0 },
> >  	{ DRM_MODE_CONNECTOR_Component, "Component", 0 },
> > -	{ DRM_MODE_CONNECTOR_9PinDIN, "9-pin DIN", 0 },
> > -	{ DRM_MODE_CONNECTOR_DisplayPort, "DisplayPort", 0 },
> > -	{ DRM_MODE_CONNECTOR_HDMIA, "HDMI Type A", 0 },
> > -	{ DRM_MODE_CONNECTOR_HDMIB, "HDMI Type B", 0 },
> > +	{ DRM_MODE_CONNECTOR_9PinDIN, "DIN", 0 },
> > +	{ DRM_MODE_CONNECTOR_DisplayPort, "DP", 0 },
> [...]
> 
> Why change 'DisplayPort', which doesn't have a space in it?  This might
> break a previously working kernel command line.

That's what happened in Linus's tree, I just mirror it :)

thanks,

greg k-h
