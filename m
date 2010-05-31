Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab0EaTiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 15:38:23 -0400
Received: from nox2.protox.org ([95.130.11.66]:44887 "EHLO protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576Ab0EaTiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 15:38:21 -0400
Date: Mon, 31 May 2010 21:38:15 +0200
From: Jerome Glisse <glisse@freedesktop.org>
To: Greg KH <greg@kroah.com>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, stable@kernel.org,
       Alex Deucher <alexdeucher@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [stable]  please consider drm radeon kms agp release
Message-ID: <20100531193815.GD2413@barney.localdomain>
References: <201005311642.49843.Martin@lichtvoll.de>
 <20100531170234.GA14235@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100531170234.GA14235@kroah.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 10:02:34AM -0700, Greg KH wrote:
> On Mon, May 31, 2010 at 04:42:41PM +0200, Martin Steigerwald wrote:
> > 
> > Hi Greg, hi stable kernel team,
> > 
> > Please consider the attached patch from Jérôme Glisse. It fixes drm radeon 
> > KMS after coming out from a snapshot cycle [1] - no matter whether I use 
> > userspace software suspend or TuxOnIce.
> > 
> > Verified on my notebook ThinkPad T42 and by cedric, the reporter of above 
> > bug.
> 
> Which stable kernel release do you want to see this patch in?  .27, .32,
> .33, or .34?  Yeah, there's a lot active at the moment :(
> 
> thanks,
> 
> greg k-h

2.6.34 sorry if i wasn't clear when ccing stable while sending patch for
2.6.35.

Cheers,
Jerome
