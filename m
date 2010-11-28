Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab0K1Tj7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 14:39:59 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40491 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab0K1Tj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 14:39:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=bi+yZiQPnrlXrm99xouP2MJzO4mCnOk0WqRRpr2X/Wj+gDbhU8PJ3Y0XSIbHBc0Gc8
         P0WRVa72XdXXYRk7i42vaD2PfMwtb/aPGCTpvxvBWBQu0vCWxzSNzG0qPThJM+FZkJBY
         bi4JVIceB9iGGI2VtiwBg3azBqnyAm7qHtgVE=
Date: Sun, 28 Nov 2010 22:36:22 +0300
From: Dan Carpenter <error27@gmail.com>
To: Patrick Schaaf <bof@bof.de>
Cc: chris@chris-wilson.co.uk, mjg@redhat.com, rpurdie@rpsys.net,
        kernelorg@bof.de, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, keithp@keithp.com
Subject: Re: back light conflict i915 vs dell-laptop
Message-ID: <20101128193622.GC30799@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Patrick Schaaf <bof@bof.de>, chris@chris-wilson.co.uk,
	mjg@redhat.com, rpurdie@rpsys.net, kernelorg@bof.de,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	keithp@keithp.com
References: <20101125093301.GT1522@bicker>
 <1290967527.4456.8.camel@lat1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290967527.4456.8.camel@lat1>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 28, 2010 at 07:05:27PM +0100, Patrick Schaaf wrote:
> On Thu, 2010-11-25 at 12:33 +0300, Dan Carpenter wrote:
> > Patrick Schaaf has reported that the i915 driver is setting his
> > backlight very dim when he starts GDM.
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=23472
> > 
> > It should be the dell-laptop platform driver controlling his backlight.
> > 
> > Gnome tries to restore the backlight settings through the dell_laptop
> > interface in sysfs but it fails.  (Because the platform hardware refuses
> > to set the settings to what it thinks they already are).
> 

Keith Packard wrote in another thread that there were some patches
to address this in his git repo:

git://people.freedesktop.org/~keithp/linux-2.6 drm-intel-next

regards,
dan carpenter


