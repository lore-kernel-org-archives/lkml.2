Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928Ab1FAT5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:57:17 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:53702 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759913Ab1FAT5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:57:15 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [alsa-devel] [PATCH v5] [resend] radio-sf16fmr2: convert to generic TEA575x interface
Date: Wed, 1 Jun 2011 21:56:59 +0200
User-Agent: KMail/1.9.10
Cc: Takashi Iwai <tiwai@suse.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        alsa-devel@alsa-project.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
References: <201105231417.17450.linux@rainbow-software.org> <s5hvcwx29co.wl%tiwai@suse.de> <4DE65E9B.7060509@redhat.com>
In-Reply-To: <4DE65E9B.7060509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106012157.03928.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 June 2011 17:45:31 Mauro Carvalho Chehab wrote:
> Em 26-05-2011 04:45, Takashi Iwai escreveu:
> > At Wed, 25 May 2011 21:21:30 -0300,
> >
> > Mauro Carvalho Chehab wrote:
> >> Em 23-05-2011 09:17, Ondrej Zary escreveu:
> >>> Convert radio-sf16fmr2 to use generic TEA575x implementation. Most of
> >>> the driver code goes away as SF16-FMR2 is basically just a TEA5757
> >>> tuner connected to ISA bus.
> >>> The card can optionally be equipped with PT2254A volume control
> >>> (equivalent of TC9154AP) - the volume setting is completely reworked
> >>> (with balance control added) and tested.
> >>
> >> Ondrej,
> >>
> >> As your first series went via alsa tree, and we are close to the end of
> >> the merge window, and assuming that Takashi didn't apply those patches
> >> on his tree, as you're re-sending it, I think that the better is to wait
> >> for the end of the merge window, in order to allow us to sync our
> >> development tree with 2.6.40-rc1, and then review and apply it on the
> >> top of it.
> >
> > Yeah, I didn't pick it up as the patches are rather V4L-side changes
> > (although tea575x.c is in sound sub-directory).
> > And I agree with Mauro - let's merge it after rc1, so that we stand on
> > the same ground.  This sort of cross-tree change is better done at the
> > fixed point than in flux like during merge window.
>
> Hmm.. I tried to apply it after -rc1. It didn't apply:
>
> Applying patch
> patches/lmml_808552_v5_resend_radio_sf16fmr2_convert_to_generic_tea575x_int
>erface.patch patching file sound/pci/Kconfig
> patching file drivers/media/radio/radio-sf16fmr2.c
> Hunk #1 FAILED at 1.
> 1 out of 2 hunks FAILED -- rejects in file
> drivers/media/radio/radio-sf16fmr2.c Patch
> patches/lmml_808552_v5_resend_radio_sf16fmr2_convert_to_generic_tea575x_int
>erface.patch does not apply (enforce with -f)
>
> Is there any missing patches, or is it just due to some other changes from
> the alsa tree?

It fails because of a stupid typo comment fix:
-/* !!! not tested, in my card this does't work !!! */
+/* !!! not tested, in my card this doesn't work !!! */


-- 
Ondrej Zary
