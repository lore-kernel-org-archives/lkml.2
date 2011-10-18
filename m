Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab1JRWNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 18:13:09 -0400
Received: from mail.danysek.cz ([91.103.163.139]:34059 "EHLO mail.danysek.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012Ab1JRWNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 18:13:07 -0400
Message-ID: <4E9DF9F1.9040606@danysek.cz>
Date: Wed, 19 Oct 2011 00:13:05 +0200
From: Daniel Suchy <danny@danysek.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Icedove/5.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: ALSA: HDA: conexant support for Lenovo T520/W520
References: <4E9D2DCA.4010603@danysek.cz> <s5h1uua3e9b.wl%tiwai@suse.de> <4E9D4011.3020602@danysek.cz> <s5hr52a1xil.wl%tiwai@suse.de>
In-Reply-To: <s5hr52a1xil.wl%tiwai@suse.de>
OpenPGP: id=A2A35A82
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/18/2011 11:04 AM, Takashi Iwai wrote:
>> There's another issue I observed related to audio outputs, but I'm not
>> sure about the reason. With docking station, audio isn't working over
>> audio output on the Minidock 3. Internal speakers are cutted off
>> properly, but there's no sound output on the connector. Audio output on
>> T520 directly works as expected, only output on minidock has this
>> problem. If you have any hints, let me know. This happens even with
>> autodetection enabled (this was my initial motivation for looking into
>> the driver source, and also CXT5066_THINKPAD quirk, which I tested
>> previously has this problem).
> 
> Might be an EAPD issue?  There is another pending patch.  Attached
> below.
> 

I tried all patches you provided, but the problem with output persists.
Tested on 3.1-rc10. I'll look on the recording issue tomorrow.

With regards,
Daniel
