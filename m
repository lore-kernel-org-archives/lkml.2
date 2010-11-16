Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab0KPVBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:01:13 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:53824 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab0KPVBL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:01:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Wd5MAjHjHS1P/x0qK71oJWlHwJXKokjwQnPatzJEMKIwEc3OQJioeBPvsyxeXZW8oU
         ylAcmy0e8VuPegk0KFv/RhZhV60nZeFv3WzLeVoKD31aAwUZ4KlkTYW2TVvqxkmHnBgW
         /M3Iw+riRSQ1cb/2iXHwrThYrmFL8nQfygJ/Q=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1011161255430.1193@chino.kir.corp.google.com>
References: <20101115093410.BEFD.A69D9226@jp.fujitsu.com>
	<20101114181905.bc5b44f9.akpm@linux-foundation.org>
	<20101115113238.BF06.A69D9226@jp.fujitsu.com>
	<alpine.DEB.2.00.1011150215460.2986@chino.kir.corp.google.com>
	<alpine.LNX.2.00.1011160027180.22346@swampdragon.chaosbits.net>
	<34565.1289866395@localhost>
	<20101116110310.1502de2a@lxorguk.ukuu.org.uk>
	<20101116140341.42561c84@schatten.dmk.lab>
	<20101116145551.49c47df5@lxorguk.ukuu.org.uk>
	<alpine.DEB.2.00.1011161255430.1193@chino.kir.corp.google.com>
Date: Tue, 16 Nov 2010 22:01:10 +0100
Message-ID: <AANLkTinE3Bb+EVb0JozwJbk0TAoHHGgJ+f1eFi2fDRCT@mail.gmail.com>
Subject: Re: [PATCH] Revert oom rewrite series
From: Fabio Comolli <fabio.comolli@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC: list trimmed again for sanity]

Another one:

[   34.709156] chromium-browse (1439): /proc/1480/oom_adj is
deprecated, please use /proc/1480/oom_score_adj instead.

2.6.37-rc2 - archlinux - package chromium-browser-ppa from AUR




On Tue, Nov 16, 2010 at 9:57 PM, David Rientjes <rientjes@google.com> wrote:
> On Tue, 16 Nov 2010, Alan Cox wrote:
>
>> Yes - so why is it spewing crap, annoying users and trying to irritate
>> application authors. It's not 2012 yet.
>>
>
> It's a WARN_ON_ONCE() so it will only spew a single line as a reminder
> that the application needs to be updated; would you prefer that to be
> suppressed until a year before removal, for example?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
