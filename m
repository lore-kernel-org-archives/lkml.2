Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab1D2IZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 04:25:14 -0400
Received: from c.painless.aaisp.net.uk ([81.187.30.53]:33477 "EHLO
	c.painless.aaisp.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab1D2IZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 04:25:11 -0400
Date: Fri, 29 Apr 2011 09:25:08 +0100
From: Andrew Clayton <andrew@digital-domain.net>
To: Takashi Iwai <tiwai@suse.de>
Cc: Emmanuel Benisty <benisty.e@gmail.com>, Greg KH <gregkh@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: 2.6.38.4 broke my audio
Message-ID: <20110429092508.35423bca@omega.digital-domain.net>
In-Reply-To: <s5hr58mgatq.wl%tiwai@suse.de>
References: <20110424113037.11af0b04@omega.digital-domain.net>
	<20110425000126.GA18681@suse.de>
	<s5htydmhed2.wl%tiwai@suse.de>
	<20110425173409.GA32047@suse.de>
	<s5hpqoagjtf.wl%tiwai@suse.de>
	<BANLkTim0UGi2Y9wE4NEMgyKQLx73garNxA@mail.gmail.com>
	<s5hvcy1b2kj.wl%tiwai@suse.de>
	<BANLkTinVWhbis7HxfQLc-89eQgg=qsFhhg@mail.gmail.com>
	<s5h39l4gkf1.wl%tiwai@suse.de>
	<BANLkTinmXbkk579oaiTqRdexvOZFpS_gvg@mail.gmail.com>
	<s5haafbae7k.wl%tiwai@suse.de>
	<BANLkTimbyDBgdCuo=feser9eRnPhS34FQA@mail.gmail.com>
	<s5hy62vfpx4.wl%tiwai@suse.de>
	<BANLkTimMQgquUD+wi6WuxzVAK8eA7kQEQQ@mail.gmail.com>
	<s5hvcxzey1z.wl%tiwai@suse.de>
	<BANLkTim22Cb3e-ST2Mphn2CRksXWa6GwDw@mail.gmail.com>
	<s5hr58mgatq.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Apr 2011 08:16:17 +0200, Takashi Iwai wrote:

> OK, but now the patch assumes that it's a mutable output, so the 
> auto-mute shall happen.
> 
> Actually other OSes seem to mute the line-out as well, so we may
> follow the standard scenario.

OK, so I guess the bit in the distribution that saves and restores
mixer settings at shutdown/startup needs updating to take this new
mixer into account? as the speaker mixer is always muted at startup
now.

Cheers,
Andrew
