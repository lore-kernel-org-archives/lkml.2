Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab3AHJCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 04:02:20 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:54225 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184Ab3AHJCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 04:02:18 -0500
Message-ID: <50EBDF1E.2060505@gmail.com>
Date: Tue, 08 Jan 2013 09:55:58 +0100
From: Maurizio Avogadro <mavoga@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121122 Icedove/10.0.11
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Vincent Blut <vincent.debian@free.fr>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [3.6.9 -> 3.7.1 regression] sound: snd_hda_intel codec probing
 issue?
References: <1356704740.3953.26.camel@lamella> <s5hvcber5cz.wl%tiwai@suse.de> <50EBD772.3090008@gmail.com> <s5htxqsyt7g.wl%tiwai@suse.de>
In-Reply-To: <s5htxqsyt7g.wl%tiwai@suse.de>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

08/01/2013 09:28 Takashi Iwai wrote:
> [...]
> 
> BTW, the problem is related rather with the controller chip, not the
> codec chip.  In Vincent's case, it's 8086:1e20,
>   Intel Corporation 7 Series/C210 Series Chipset Family High
>   Definition Audio Controller (rev 04)

Here I have

00:1b.0 0403: 8086:1c20 (rev 05)
00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset
Family High Definition Audio Controller (rev 05)

Thanks


Maurizio
