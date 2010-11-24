Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab0KXKVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 05:21:46 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47256 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab0KXKVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 05:21:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=P9AAxNIr/FVzLhRgkuRSFoPEZlniJ/42fuAlY+Dc7dIxobzoaUnLkwbvHtLOF1i4QG
         YOAFEVhhE9v4R2SQxdQ0L6/B3HQtQycxZU4ozj3J7wY8q75F07BIrnAQdRig4kCg7WLi
         CvYJfaNAG9O4OHTWdim3gfn7qYr7GvfDKEt2c=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTin_Cd8_LLt2qizmMTgsC2nixr4Nb-yeKyL5gYEg@mail.gmail.com>
References: <AANLkTin_Cd8_LLt2qizmMTgsC2nixr4Nb-yeKyL5gYEg@mail.gmail.com>
Date: Wed, 24 Nov 2010 11:21:43 +0100
Message-ID: <AANLkTi=EhpyDbZ-3WLUGkKE947agd-1Vth6WxXqndDVY@mail.gmail.com>
Subject: Re: linux-next: Tree for November 24 (drm/drm-next)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: sfr@canb.auug.org.au
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 6:56 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> Hi,
>
> it does not look like the recent drm-2.6/drm-next commits [1] were
> pulled into linux-next.
> These commits are 30hrs vs. [2] is 3hrs young.
> Also the merge.log [3] shows no drm hits.
> Forgot to pull in?
>
> Regards,
> - Sedat -
>
> [1] http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=shortlog;h=refs/heads/drm-next
> [2] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=shortlog
> [3] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=blob;f=Next/merge.log;h=12a8df5cf3aa4d51798e26160e7312efda88b065;hb=bd59982e813e8bf45901f6ba216f600cddcbc25a
>

Sorry, my bad... looks good with drm-next.

- Sedat -

$ cd linux-next/

$ git pull git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
drm-next
>From git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6
 * branch            drm-next   -> FETCH_HEAD
Already up-to-date.

$ git log -2 drivers/gpu/drm/radeon/ | cat
commit fd451078e3517930f402f55b861d204ae9bb4b51
Merge: 7ff2f64 dca25eb
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Wed Nov 24 11:52:49 2010 +1100

    Merge remote branch 'trivial/for-next'

    Conflicts:
        MAINTAINERS
        drivers/scsi/bfa/bfa_fcpim.c

commit 1040cc0dae5d3a8e58d42843ec687f7286dc554c
Merge: ea26450 439bd6c
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Nov 23 09:24:15 2010 +1000

    Merge branch 'drm-radeon-fusion' of ../drm-radeon-next into
drm-next

    * 'drm-radeon-fusion' of ../drm-radeon-next:
      drm/radeon/kms: add Ontario APU ucode loading support
      drm/radeon/kms: add Ontario Fusion APU pci ids
      drm/radeon/kms: enable MSIs on fusion APUs
      drm/radeon/kms: add power table parsing support for Ontario fusion APUs
      drm/radeon/kms: refactor atombios power state fetching
      drm/radeon/kms: add bo blit support for Ontario fusion APUs
      drm/radeon/kms: add thermal sensor support for fusion APUs
      drm/radeon/kms: fill in GPU init for AMD Ontario Fusion APUs
      drm/radeon/kms: add radeon_asic struct for AMD Ontario fusion APUs
      drm/radeon/kms: evergreen.c updates for fusion
      drm/radeon/kms: MC setup changes for fusion APUs
      drm/radeon/kms: move r7xx/evergreen to its own vram_gtt setup function
      drm/radeon/kms: add support for ss overrides on Fusion APUs
      drm/radeon/kms: Add support for external encoders on fusion APUs
      drm/radeon/kms: atom changes for DCE4.1 devices
      drm/radeon/kms: add new family id for AMD Ontario APUs
      drm/radeon/kms: upstream power table updates
      drm/radeon/kms: upstream atombios.h updates
      drm/radeon/kms: upstream ObjectID.h updates
      drm/radeon/kms: setup mc chremap properly on r7xx/evergreen
