Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab1AaU4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 15:56:07 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49038 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab1AaU4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 15:56:05 -0500
From: Patrick Boettcher <pboettcher@kernellabs.com>
Organization: KernelLabs Inc.
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PULL for 2.6.38-rc2] V4L/DVB patches
Date: Mon, 31 Jan 2011 21:55:59 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-trunk-amd64; KDE/4.4.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4D386A69.3080000@redhat.com> <4D398755.7040107@redhat.com>
In-Reply-To: <4D398755.7040107@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101312155.59363.pboettcher@kernellabs.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Friday 21 January 2011 14:17:09 Mauro Carvalho Chehab wrote:
> Linus,
> 
> Em 20-01-2011 15:01, Mauro Carvalho Chehab escreveu:
> > Hi Linus,
> > 
> > Those are some changes that I tried to prepare to send you during the
> > merge window, but, unfortunately, the new videobuf2 driver took me a
> > longer time to review/test than I originally expected.
> > 
> > Please pull from:
> >   ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
> >   v4l_for_linus
> 
> Please, don't pull yet. There are some changesets that have some
> weird stuff, like this:
> 
> diff --git a/drivers/staging/vme/bridges/Module.symvers
> b/drivers/staging/vme/bridges/Module.symvers deleted file mode 100644
> index e69de29..0000000
> 
> I have no idea why those things appeared, as I never handled any patch
> that touched inside drivers/staging/vme. I need to further investigate
> the entire patchset and see if other weird stuff happened there.
> 
> I'll send you another pull request after fixing those things.

Do you think those changesets will make it into 2.6.38 at some point? I'm 
asking because this is where the technisat-driver is currently residing on his 
way into the kernel.  I understand that there is a problem in this branch, but 
still I'd like to see the technisat-usb2 being merged.

I'm getting a little bit desperate. :-(

Can I do something to help?

best regards,
--
Patrick Boettcher - KernelLabs
http://www.kernellabs.com/
