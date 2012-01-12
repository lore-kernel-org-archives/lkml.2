Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab2ALQGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 11:06:32 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35148 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab2ALQGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 11:06:30 -0500
MIME-Version: 1.0
In-Reply-To: <s5hhb01dow9.wl%tiwai@suse.de>
References: <s5hhb01dow9.wl%tiwai@suse.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Jan 2012 08:06:09 -0800
X-Google-Sender-Auth: Hh-n-8SiMKLhEPh7_kn1-X3h2QE
Message-ID: <CA+55aFxsadM=AGpS6b+pcCHu2L8DoQVEVx_Y4hjfY1AvvqhZcQ@mail.gmail.com>
Subject: Re: [GIT PULL] sound updates for 3.3-rc1
To: Takashi Iwai <tiwai@suse.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 5:35 AM, Takashi Iwai <tiwai@suse.de> wrote:
>
> please pull sound updates for v3.3-rc1 from:

Ok, pulled. However, as with a few other pulls in this merge window, I
reacted to a new config question that isn't sensible from a user
perspective:

  ALSA Compressed audio offload support (SND_COMPRESS_OFFLOAD) [N/y/?] (NEW) ?

Does it really make any sense at all to ask a user this question? Why
don't the drivers that support compressed audio offload just select
this helper instead?

                           Linus
