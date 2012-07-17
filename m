Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab2GQXqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 19:46:37 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40778 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab2GQXq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 19:46:28 -0400
MIME-Version: 1.0
In-Reply-To: <s5hmx2ylgkr.wl%tiwai@suse.de>
References: <CADLC3L3dDOG8BBXR0zWn9SqM0BUotpW0Y+C=HUMEK-SAGCFLJg@mail.gmail.com>
	<s5hmx2ylgkr.wl%tiwai@suse.de>
Date: Tue, 17 Jul 2012 17:46:27 -0600
Message-ID: <CADLC3L0yUcXS4KG2Fxj2W9-f2U08ODxAn0_7iWK7=ECSVnGgBA@mail.gmail.com>
Subject: Re: 3.4.4: Oops in snd_hda_codec_realtek (alc_auto_create_multi_out_ctls)
From: Robert Hancock <hancockrwd@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Alsa-Devel <alsa-devel@alsa-project.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 6:25 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Mon, 9 Jul 2012 13:40:09 -0600,
> Robert Hancock wrote:
>>
>> I've got a sort of industrial portable PC that uses a Supermicro C2SBX
>> motherboard. Running an RHEL6 kernel (2.6.32-ish) it works fine, but
>> if I run a 3.4.4 kernel (using the kernel-ml builds provided by ELRepo
>> for RHEL6) it blows up on boot inside snd_hda_codec_realtek. Below is
>> the dmesg output from bootup up to the oops, after I blacklisted
>> snd_hda_intel from auto-loading and then manually modprobed it. Is
>> this a known problem?
>
> I don't know of this issue, so need to check more.
> Could you load snd-hda-intel module with probe_only=1 option, and run
> alsa-info.sh with --no-upload option and give the output?
> Then I can try the emulator to see what's wrong.
>
> Also, of course, testing a newer kernel like 3.5-rc7 would be helpful,
> too.

Unfortunately this machine is about to ship back out to a customer so
there's not really any more info I can gather from it at this point.
If I can get hold of it or a similar machine again in the future, I
can try to get more information.
