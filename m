Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750Ab2DMNhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 09:37:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754969Ab2DMNhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 09:37:31 -0400
Date: Fri, 13 Apr 2012 09:37:21 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org
Subject: Re: Thinkpad hda regression in 3.3
Message-ID: <20120413133721.GE25425@zod.bos.redhat.com>
References: <20120413124306.GC25425@zod.bos.redhat.com>
 <s5hpqbbvkzo.wl%tiwai@suse.de>
 <20120413132352.GD25425@zod.bos.redhat.com>
 <s5hk41jvjy2.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hk41jvjy2.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 03:29:41PM +0200, Takashi Iwai wrote:
> At Fri, 13 Apr 2012 09:23:52 -0400,
> Josh Boyer wrote:
> > > The problem regarding the docking station is basically a BIOS issue.
> > > ThinkPad BIOS doesn't expose the pins for docking stations at all.
> > > We have already a workaround for X200, and similar others would be
> > > needed for T410, T420, etc.
> > > 
> > > For testing, you don't need even patch the driver.  When the driver is
> > > built with CONFIG_SND_HDA_PATCH_LOADER=y, create a file containing the
> > > below as /lib/firmware/alsa-tp-dock:
> > > 
> > > ================================================================
> > > [codec]
> > > 0x14f15069 0x17aa21a4 0
> > > 
> > > [pincfg]
> > > 0x1a 0x21a11000
> > > 0x1c 0x23014250
> > > ================================================================
> > 
> > The above is for the X200 docking station, correct?  So it should work
> > with an x201 thinkpad in an x200 dock.
> 
> It's for T410/T510 dock.  But X201 uses the same codec chip, so this
> could be used, too.  Just give it a try.

OK.  I've asked a reporter to test this out.  We'll get back to you.

josh
