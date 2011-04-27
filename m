Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab1D0BFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 21:05:45 -0400
Received: from c.painless.aaisp.net.uk ([81.187.30.53]:48868 "EHLO
	c.painless.aaisp.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab1D0BFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 21:05:44 -0400
Date: Wed, 27 Apr 2011 02:05:40 +0100
From: Andrew Clayton <andrew@digital-domain.net>
To: Takashi Iwai <tiwai@suse.de>
Cc: Greg KH <gregkh@suse.de>, Emmanuel Benisty <benisty.e@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: 2.6.38.4 broke my audio
Message-ID: <20110427020540.25803862@omega.digital-domain.net>
In-Reply-To: <s5hwrihb2wm.wl%tiwai@suse.de>
References: <20110424113037.11af0b04@omega.digital-domain.net>
	<20110425000126.GA18681@suse.de>
	<s5htydmhed2.wl%tiwai@suse.de>
	<20110425173409.GA32047@suse.de>
	<s5hpqoagjtf.wl%tiwai@suse.de>
	<20110426011212.77630c68@omega.digital-domain.net>
	<s5hwrihb2wm.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011 14:41:45 +0200, Takashi Iwai wrote:

> At Tue, 26 Apr 2011 01:12:12 +0100,
> Andrew Clayton wrote:
> > 
> > On Mon, 25 Apr 2011 22:25:16 +0200, Takashi Iwai wrote:
> > 
> > > Andrew, could you give alsa-info.sh outputs on your machine?
> > > Preferably, the outputs both before and after the kernel update
> > > would be really helpful.
> > 
> > Sure, here you go.
> > 
> > The first one is from 2.6.38.3 where the audio is fine. The second
> > is from 2.6.38.4 where the audio is really quiet.
> 
> Thanks.  In your case, "Speaker" mixer volume is set to zero.
> Does the following fix the output?
> 
> 	% amixer -c0 set Speaker 100%

Ah, indeed it does.

> Takashi

Cheers,
Andrew
