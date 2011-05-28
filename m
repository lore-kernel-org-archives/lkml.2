Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab1E1AIM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 20:08:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755654Ab1E1AIK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 20:08:10 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=SsE2RVoZW0mq6NdjsNeK1r_hx6Q@mail.gmail.com>
References: <s5haae8jx7h.wl%tiwai@suse.de> <BANLkTi=SsE2RVoZW0mq6NdjsNeK1r_hx6Q@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 May 2011 17:02:18 -0700
Message-ID: <BANLkTim3Sr3ZfUda2bwhfw8O7qtQ3tXNmQ@mail.gmail.com>
Subject: Re: [GIT PULL] sound updates #2 for 2.6.40
To: Takashi Iwai <tiwai@suse.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 4:50 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Ok, I've bisected the sound problems on my machine to one of three.
> It's somewhere in this range:
>
>  af4ccf4f86c0..9477c58e3308
>
> probably it's that last one ("ALSA: hda - Reorganize controller quriks
> with bit flags").

Confirmed. Also confirmed that reverting that from current tip of git
fixes the issue.

Takashi, do you see anything obviously wrong in there, or should I
just go ahead and revert?

                        Linus
