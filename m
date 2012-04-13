Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab2DMSI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:08:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311Ab2DMSI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:08:26 -0400
Date: Fri, 13 Apr 2012 14:08:14 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org
Subject: Re: Thinkpad hda regression in 3.3
Message-ID: <20120413180814.GG25425@zod.bos.redhat.com>
References: <20120413124306.GC25425@zod.bos.redhat.com>
 <s5hpqbbvkzo.wl%tiwai@suse.de>
 <s5hk41jty24.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hk41jty24.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 06:07:47PM +0200, Takashi Iwai wrote:
> At Fri, 13 Apr 2012 15:07:07 +0200,
> Takashi Iwai wrote:
> (snip)
> > If the above seem work (again, make sure that you adjust the mixer
> > mutes and levels), I'll make kernel patches to add these fixups
> > statically in the driver so that it works without extra patching.
> 
> Looking through alsa-info.sh outputs from various ThinkPad models I've
> gathered, it seems that we can use the same pin setups for all.

We had a user try the alsa-tp-dock patch on an X201 and it didn't seem
to work for them.  See bug
https://bugzilla.redhat.com/show_bug.cgi?id=806217

Perhaps the [codec] section isn't set properly for their configuration?
The alsa-info for their machine is in comment #9 of the bug.

> Below is a test patch for 3.3 kernel.  (Note that it'd give a merge
> conflict for 3.4 kernel.)

OK, I'll do a scratch build with this and get people to test.

josh
