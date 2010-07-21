Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751047Ab0GUEIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:08:45 -0400
Received: from mailout-us.gmx.com ([74.208.5.67]:41306 "HELO
	mailout-us.gmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750774Ab0GUEIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:08:44 -0400
X-Authenticated: #61118693
X-Provags-ID: V01U2FsdGVkX1/BiUYzsajBXcGfbQ6bHxR7fHsC45Jg+/x89g2bis
	Wxp4pRzerGIUuB
Message-ID: <4C4672D4.9030400@gmx.com>
Date: Wed, 21 Jul 2010 09:38:52 +0530
From: David John <davidjon@gmx.com>
Reply-To: davidjonx@gmail.com
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1.9) Gecko/20100430 Thunderbird/3.0.4
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Multiple Codec Problem With Intel HD Audio
References: <4C432E1D.3000703@gmx.com> <s5hwrsrxdrx.wl%tiwai@suse.de>
In-Reply-To: <s5hwrsrxdrx.wl%tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, this looks like the issue.
> 
> A possible fix without much hustle would be to define mode quirks for
> both codecs by checking the PCI SSID so that they won't conflict.

How would I go about doing this as the dmesg dump had the following:

> ALSA sound/pci/hda/patch_realtek.c:1287: realtek: *No valid SSID*,
> checking pincfg 0x40000001 for NID 0x1d
> ALSA sound/pci/hda/patch_realtek.c:1303: realtek: Enabling init
> ASM_ID=0x0001 CODEC_ID=10ec0888

Thanks,
David.
