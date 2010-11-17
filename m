Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935475Ab0KQUBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 15:01:36 -0500
Received: from eazy.amigager.de ([213.239.192.238]:33350 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935449Ab0KQUBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 15:01:35 -0500
Date: Wed, 17 Nov 2010 21:01:49 +0100
From: Tino Keitel <tino.keitel@tikei.de>
To: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: DVI/EDID broken with Intel i945 graphics and 2.6.37-rc2
Message-ID: <20101117200149.GA30815@mac.home>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Chris Wilson <chris@chris-wilson.co.uk>
References: <20101116184914.GA15794@mac.home>
 <b9dded$h40vqf@orsmga002.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9dded$h40vqf@orsmga002.jf.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 10:20:09 +0000, Chris Wilson wrote:
> On Tue, 16 Nov 2010 19:49:14 +0100, Tino Keitel <tino.keitel@tikei.de> wrote:
> > Hi,
> > 
> > 2.6.37-rc2 doesn't seem to detect the LCD connected via DVI on my Mac
> > mini Core2 Duo with i945 graphics:
> 
> Hmm, sounds like fallout from detection of the VGA connection on the shared
> GPIO wire.
> 
> Does this help?

No. I still get this:

No connectors reported connected with modes
[drm] Cannot find any crtc or sizes - going 1024x768

Regards,
Tino
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

