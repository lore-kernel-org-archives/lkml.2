Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab0FWSXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 14:23:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42913 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab0FWSXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 14:23:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=IGdZZsePa4svTcVkRMBQpaEcw9e2uu07v9zL49nygmbw3klJPb/uI/UJvykTDV85fE
         GLJ/0pxa3WEPxWISzdUzT7QgRkE2E0jjfP+ep9nYrHHaqDVW5cTkOPFIpAL1F43f7D3a
         g0+D+GZKIiAX7cmTqtK25NkiB20iDcC/vZA78=
MIME-Version: 1.0
Reply-To: linux@schou.dk
In-Reply-To: <1277271419.10818.22.camel@obelisk.thedillows.org>
References: <AANLkTimO5PXmJiIPDw82MTA53mLSl-OC0e1SOEh7v8pH@mail.gmail.com> 
	<1276972298.22889.16.camel@obelisk.thedillows.org> <AANLkTimwZFNLBNJWODyzKXwx9CbIorg3OCA53XZchkeN@mail.gmail.com> 
	<1277043970.22889.45.camel@obelisk.thedillows.org> <AANLkTikBTMq3d-Ov65wYLJ_Vw-7Jde4AOwfXcEPB0wLr@mail.gmail.com> 
	<1277129180.22889.64.camel@obelisk.thedillows.org> <AANLkTikW71h7ABVXY21pLL9AeOlmRTfVaSTjJ_6Ma0_R@mail.gmail.com> 
	<AANLkTikCGzUKe9Fy1d0xhberqGFe71lvrQbg5gkQzgf1@mail.gmail.com> 
	<AANLkTikPW9j4H15gq7nl0Tb213R15uIQAnSDi_cTOJre@mail.gmail.com> 
	<1277262047.10818.9.camel@obelisk.thedillows.org> <1277271419.10818.22.camel@obelisk.thedillows.org>
From: Hans Schou <linux@schou.dk>
Date: Wed, 23 Jun 2010 20:22:56 +0200
X-Google-Sender-Auth: WV8nEf7XcPjp8saL4_ZVkDzkzQk
Message-ID: <AANLkTiln40Xo3fHbMSkEvdBUtFq8ZWrF57wgRWdU2Juc@mail.gmail.com>
Subject: Re: PROBLEM: SIS7019 stops recording after 42 min
To: David Dillow <dave@thedillows.org>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/23 David Dillow <dave@thedillows.org>:

> I can reproduce the alternating pattern of periods using a different
> device, so this may be something in the core code of ALSA.

Strange? The program I am actually using is one I have written myself.
I was sure I was using the old method as I open(2). In my program I
use
   int fd = open("/dev/dsp",  O_RDWR);

This should not go through ALSA (I think). I gues one should use
something with "snd_pcm_open()" to use ALSA.

> Since this problem is not related to the SiS7019 driver, I'll leave it
> to later -- or for others to investigate. Using three periods per buffer
> sees a similar pattern, but one has an extra period time to work
> within.

I really don't understand why I do not see this problem on other
hardware using the same compiled code.

If the problem is ALSA, how can I then turn it off?

Thanks for your investigation.

regards/hans
