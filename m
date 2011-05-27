Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab1E0Xuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 19:50:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757046Ab1E0Xud convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 19:50:33 -0400
MIME-Version: 1.0
In-Reply-To: <s5haae8jx7h.wl%tiwai@suse.de>
References: <s5haae8jx7h.wl%tiwai@suse.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 May 2011 16:50:08 -0700
Message-ID: <BANLkTi=SsE2RVoZW0mq6NdjsNeK1r_hx6Q@mail.gmail.com>
Subject: Re: [GIT PULL] sound updates #2 for 2.6.40
To: Takashi Iwai <tiwai@suse.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 2:42 AM, Takashi Iwai <tiwai@suse.de> wrote:
>
> please pull sound updates (part 2) for v2.6.40-rc1 from:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git for-linus

Ok, I've bisected the sound problems on my machine to one of three.
It's somewhere in this range:

  af4ccf4f86c0..9477c58e3308

probably it's that last one ("ALSA: hda - Reorganize controller quriks
with bit flags").

I'll have it fully bisected soon enough.

                     Linus
