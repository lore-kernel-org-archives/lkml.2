Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909Ab1ENTbB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 15:31:01 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:43497 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab1ENTa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 15:30:59 -0400
Date: Sat, 14 May 2011 16:31:34 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: Wavering Arrandale output
Message-ID: <20110514193134.GA2269@joana>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20110513204511.GA2187@joana>
 <013811$1gi55@fmsmga002.fm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <013811$1gi55@fmsmga002.fm.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Wilson <chris@chris-wilson.co.uk> [2011-05-14 08:55:15 +0100]:

> On Fri, 13 May 2011 17:45:11 -0300, "Gustavo F. Padovan" <padovan@profusion.mobi> wrote:
> > Hi Chris,
> > 
> > Bug #28306 is going to complete his first birthday at the end of this month,
> > it is nagging around for a long time and I have many interest in fix this.
> > 
> > So I tested your patch in duplicated bug #36599 and it doesn't work, but I
> > managed to add some printks(see diff) there to help debug.
> > 
> > [    1.033866] [drm:intel_crtc_mode_set] *ERROR* 1. use_ssc 1
> > [    1.033868] [drm:intel_crtc_mode_set] *ERROR* encoder->type 4
> > [    1.033869] [drm:intel_crtc_mode_set] *ERROR* 2. use_ssc 1
> > [    1.034120] [drm:intel_crtc_mode_set] *ERROR* is_lvds 1
> > [    1.034121] [drm:intel_crtc_mode_set] *ERROR* has_edp_encoder
> > (null)
> > [    1.191465] [drm:intel_crtc_mode_set] *ERROR* 1. use_ssc 1
> > [    1.191466] [drm:intel_crtc_mode_set] *ERROR* encoder->type 4
> > [    1.191468] [drm:intel_crtc_mode_set] *ERROR* encoder->type 1
> > [    1.191469] [drm:intel_crtc_mode_set] *ERROR* 2. use_ssc 0
> > [    1.191720] [drm:intel_crtc_mode_set] *ERROR* is_lvds 0
> > [    1.191721] [drm:intel_crtc_mode_set] *ERROR* has_edp_encoder
> > (null)
> > 
> > It seems your patch has no effect once has_edp_encoder is null. Can you please
> > look into this? I can provide any test you may want, just send me the patches.
> > ;)
> 
> With no eDP on the system, we wouldn't expect to apply any of the eDP
> settings.
> 
> Even after your fix to the patch, nothing? Can you try just setting
> use_ssc=0 (and keep your fix).

Nothing.

-- 
Gustavo F. Padovan
http://profusion.mobi
