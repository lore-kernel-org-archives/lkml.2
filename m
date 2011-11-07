Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1KGT0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 14:26:14 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39415 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab1KGT0N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 14:26:13 -0500
MIME-Version: 1.0
In-Reply-To: <20111107191200.GH30282@windriver.com>
References: <20111107173318.12d4a5ce67a522b000d4a78c@canb.auug.org.au>
	<20111107191200.GH30282@windriver.com>
Date: Mon, 7 Nov 2011 14:26:11 -0500
X-Google-Sender-Auth: wScdueEmyijkvvNHuka4r2S1AjM
Message-ID: <CAP=VYLqp1KcsE3UMt2-xuMp-gwtyLWfwdNmzxBvZZ=bZT_6E2w@mail.gmail.com>
Subject: Re: [GIT PULL] Left overs from the module.h split merge
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 7, 2011 at 2:12 PM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:

>
> The following changes since commit 31555213f03bca37d2c02e10946296052f4ecfcd:
>
>  Revert "hvc_console: display printk messages on console." (2011-11-06 22:22:16 -0800)
>
> are available in the git repository at:
>  git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git for-linus
>
> Jonas Gorski (1):
>      MTD: MAPS: bcm963xx-flash.c: explicitly include module.h
>
> Paul Gortmaker (3):
>      drivers/md: change module.h -> export.h in persistent-data/dm-*
>      arm: Add export.h to recently added files for EXPORT_SYMBOL
>      mfd: fix build failures in recently added ab5500 code
>
> Stephen Rothwell (2):
>      device-mapper: dm-bufio.c needs to include module.h
>      device-mapper: using EXPORT_SYMBOL in dm-space-map-checker.c needs export.h

For completeness, the above also should have listed including this:

Axel Lin (1):
      hwspinlock/u8500: include linux/module.h

 drivers/hwspinlock/u8500_hsem.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

Thanks,
Paul.
