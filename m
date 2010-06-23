Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab0FWUiF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 16:38:05 -0400
Received: from kroah.org ([198.145.64.141]:41230 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399Ab0FWUiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 16:38:03 -0400
Date: Wed, 23 Jun 2010 13:28:06 -0700
From: Greg KH <greg@kroah.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Jerome Glisse <glisse@freedesktop.org>, stable@kernel.org,
       Alex Deucher <alexdeucher@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [stable]  please consider drm radeon kms agp release
Message-ID: <20100623202806.GA2281@kroah.com>
References: <201005311642.49843.Martin@lichtvoll.de>
 <20100531170234.GA14235@kroah.com>
 <20100531193815.GD2413@barney.localdomain>
 <201005312356.27299.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201005312356.27299.Martin@lichtvoll.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 11:56:26PM +0200, Martin Steigerwald wrote:
> Am Montag 31 Mai 2010 schrieb Jerome Glisse:
> > On Mon, May 31, 2010 at 10:02:34AM -0700, Greg KH wrote:
> > > On Mon, May 31, 2010 at 04:42:41PM +0200, Martin Steigerwald wrote:
> > > > Hi Greg, hi stable kernel team,
> > > > 
> > > > Please consider the attached patch from Jérôme Glisse. It fixes drm
> > > > radeon KMS after coming out from a snapshot cycle [1] - no matter
> > > > whether I use userspace software suspend or TuxOnIce.
> > > > 
> > > > Verified on my notebook ThinkPad T42 and by cedric, the reporter of
> > > > above bug.
> > > 
> > > Which stable kernel release do you want to see this patch in?  .27,
> > > .32, .33, or .34?  Yeah, there's a lot active at the moment :(
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > 2.6.34 sorry if i wasn't clear when ccing stable while sending patch
> > for 2.6.35.
> 
> Yeah forgot to mention it also, in 2.6.33 it works. In 2.6.35 its fixed. So 
> it applies for 2.6.34.

All queued up now, thanks.

greg k-h
