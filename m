Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626Ab2HXWbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 18:31:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933572Ab2HXWbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 18:31:06 -0400
Date: Fri, 24 Aug 2012 18:30:54 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Daniel Mack <daniel@zonque.org>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        bruno@wolff.to, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: Logitech USB headset not working in 3.6-rc3
Message-ID: <20120824223054.GD20043@zod.bos.redhat.com>
References: <20120824190808.GC20043@zod.bos.redhat.com>
 <CACTFLANKY7KcXN5EcXTy3r6AAjWdUXJ41jiwAbg-V2Ag_qGpkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACTFLANKY7KcXN5EcXTy3r6AAjWdUXJ41jiwAbg-V2Ag_qGpkA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 11:30:12PM +0200, Daniel Mack wrote:
> On Fri, Aug 24, 2012 at 9:08 PM, Josh Boyer <jwboyer@redhat.com> wrote:
> > Hi All,
> >
> > We've had a report[1] that the Logitech USB headset 0003:046D:0A0C isn't
> > working with 3.6-rc3.  It seems the last working kernel was based on
> > commit 10c63c9, and it first stopped working with a kernel based on
> > commit 23dcfa6.  There are only a few ALSA commits between those
> > revisions, so hopefully this is something that is fairly easy to
> > identify.  The only commit to USB audio in that set is:
> >
> > commit e9ba389c5ffc4dd29dfe17e00e48877302111135
> > Author: Takashi Iwai <tiwai@suse.de>
> > Date:   Wed Aug 15 12:32:00 2012 +0200
> >
> >     ALSA: usb-audio: Fix scheduling-while-atomic bug in PCM capture stream
> >
> >
> > I've CC'd the reporter and attached the alsa-info is below.
> 
> Does it work again once you revert that commit?

Haven't built a kernel with that done yet.  Had a few other things pop
up this afternoon.  If Bruno doesn't build one himself, I'll try to get
one built later this evening for testing.

josh
