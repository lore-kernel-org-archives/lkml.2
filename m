Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab2HLSdL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 14:33:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58326 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab2HLSdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 14:33:09 -0400
Date: Sun, 12 Aug 2012 11:33:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Kamal Mostafa <kamal@canonical.com>, Carsten Emde <C.Emde@osadl.org>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: Re: 3.6-rc1 breaks my laptop graphics (intel)
Message-ID: <20120812183305.GA17759@kroah.com>
References: <20120812182157.GA1949@kroah.com>
 <20120812182530.GG5575@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120812182530.GG5575@phenom.ffwll.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2012 at 08:25:31PM +0200, Daniel Vetter wrote:
> On Sun, Aug 12, 2012 at 11:21:57AM -0700, Greg KH wrote:
> > Hi Daniel.
> > 
> > The 3.6-rc1 kernel breaks my laptop, booting to a black screen when the
> > i915 driver initializes itself.  I bisected this down to commit
> > 24ded204429fa0f5501d37c63ee35c555c0b75ee (drm/i915: properly enable the
> > blc controller on the right pipe), and when I revert that, and also
> > a4f32fc3a37e982fffce8ec583643990ff288419 (drm/i915: don't forget the PCH
> > backlight registers) which depended on the first patch, my laptop works
> > just fine.
> > 
> > Below is the combined revert.
> > 
> > Any thoughts?  Any patch I can try out?
> 
> http://cgit.freedesktop.org/~danvet/drm-intel/commit/?h=drm-intel-fixes&id=770c12312ad617172b1a65b911d3e6564fc5aca8
> 
> which is already merged to drm-intel-fixes.

Ah, thanks, I'll go try that out, the Subject: line didn't draw my
attention to it being the same problem as mine :)

greg k-h
