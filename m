Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab1GWSGn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 14:06:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752379Ab1GWSGh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 14:06:37 -0400
MIME-Version: 1.0
In-Reply-To: <s5hsjpx3qm7.wl%tiwai@suse.de>
References: <s5hsjpx3qm7.wl%tiwai@suse.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 23 Jul 2011 11:06:14 -0700
Message-ID: <CA+55aFwzxiVMsd6RQ8X3WVWScFSWSoFfDEBEh3pEDhoPYbEcaA@mail.gmail.com>
Subject: Re: [GIT PULL] sound updates for 3.1-rc1
To: Takashi Iwai <tiwai@suse.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 23, 2011 at 9:32 AM, Takashi Iwai <tiwai@suse.de> wrote:
>
> As you can see below, the diffstat shows awfully huge numbers.  It's
> mainly the reworks of two HD-audio drivers after I finally had some
> spare time and a gut to face them.  Most of LOCs there are due to code
> split, but also a significant amount of code reduction has been done,
> too.  In addition, as usual, many ASoC fixes/updates have been applied
> in this cycle, too.

So wrt that whole HDA thing, can somebody explain what the difference
between a "patch" and a "quirk" is? It looks like the "quirks" are
smaller patches (they all seem to be about realtek, at least
currently).

And does it really make sense to use #include to get the *.c files?
Wouldn't it be much nicer to have a "realtek" subdirectory and link
those together.

I don't care deeply, but the whole HDA source organization is getting
pretty darn ugly, I have to say.

                   Linus
