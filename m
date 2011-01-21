Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab1AUNRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 08:17:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647Ab1AUNRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 08:17:15 -0500
Message-ID: <4D398755.7040107@redhat.com>
Date: Fri, 21 Jan 2011 11:17:09 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for 2.6.38-rc2] V4L/DVB patches
References: <4D386A69.3080000@redhat.com>
In-Reply-To: <4D386A69.3080000@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Em 20-01-2011 15:01, Mauro Carvalho Chehab escreveu:
> Hi Linus,
> 
> Those are some changes that I tried to prepare to send you during the 
> merge window, but, unfortunately, the new videobuf2 driver took me a longer
> time to review/test than I originally expected.
> 
> Please pull from:
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Please, don't pull yet. There are some changesets that have some
weird stuff, like this:

diff --git a/drivers/staging/vme/bridges/Module.symvers b/drivers/staging/vme/bridges/Module.symvers
deleted file mode 100644
index e69de29..0000000

I have no idea why those things appeared, as I never handled any patch
that touched inside drivers/staging/vme. I need to further investigate
the entire patchset and see if other weird stuff happened there.

I'll send you another pull request after fixing those things.

Thanks,
Mauro

