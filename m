Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab1BHQIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 11:08:53 -0500
Received: from mailout11.t-online.de ([194.25.134.85]:39641 "EHLO
	mailout11.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab1BHQIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 11:08:52 -0500
Message-ID: <4D516A85.5070604@t-online.de>
Date: Tue, 08 Feb 2011 17:08:37 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>
CC: tiwai@suse.de, linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: ALSA: Reasonable buffer size / where should it be implemented?
References: <4D511552.7030409@t-online.de> <alpine.LNX.2.00.1102081109170.6272@eeebox2.perex-int.cz>
In-Reply-To: <alpine.LNX.2.00.1102081109170.6272@eeebox2.perex-int.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ID: TuZoqwZCZhLRUg+9qJ-oi8xDnArGH3vEffHbvfsvliqTKDk13NxFTt6ZQFzuWjdQkV
X-TOI-MSGID: 3ce07dd7-4060-45d7-bece-e858d9b63d13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> It's probably the right way to go. I would only copy data in a tasklet
> not directly in the interrupt routine. New hardware (like HDA) have
> scatter-gather DMA buffers with almost unlimited size, so users can
> just tune the system up.
>
Well, obviously recording to /dev/null has a better chance not to
hit xrun problems ;-)

So I'll clean up my q&d rme96.c code and submit it.

I have not had a look at the sources ... is arecord "right behaving"
or which command line recording tool could be used if it is not?

cu,
 Knut
