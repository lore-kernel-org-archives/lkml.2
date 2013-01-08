Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab3AHOcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 09:32:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53690 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab3AHOcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 09:32:15 -0500
Message-ID: <50EC2DED.7050207@canonical.com>
Date: Tue, 08 Jan 2013 15:32:13 +0100
From: David Henningsson <david.henningsson@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Vincent Blut <vincent.debian@free.fr>, alsa-devel@alsa-project.org,
        Maurizio Avogadro <mavoga@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [3.6.9 -> 3.7.1 regression] sound: snd_hda_intel
 codec probing issue?
References: <1356704740.3953.26.camel@lamella> <s5hvcber5cz.wl%tiwai@suse.de> <1357421043.3912.13.camel@lamella> <s5h38ydpf45.wl%tiwai@suse.de> <1357648135.3849.7.camel@lamella> <s5hehhvq1dm.wl%tiwai@suse.de>
In-Reply-To: <s5hehhvq1dm.wl%tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2013 01:56 PM, Takashi Iwai wrote:
>> I'll test with enable_msi=0 later.
>
> Thanks.
>
> FWIW, below is a patch I'm considering to merge (after testing, of
> course).  Could you buys check it?
>
>
> Takashi
>
> ---
> From: Takashi Iwai <tiwai@suse.de>
> Subject: [PATCH] ALSA: hda - Disable runtime D3 for Intel CPT & co

For reference, I'm seeing some of this too, and have asked for people to 
test with enable_msi=0 and/or power_save_controller=0. I'm waiting for 
replies from people with the hardware.


-- 
David Henningsson, Canonical Ltd.
https://launchpad.net/~diwic
