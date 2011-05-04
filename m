Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab1EDIHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 04:07:48 -0400
Received: from mail-px0-f170.google.com ([209.85.212.170]:49538 "EHLO
	mail-px0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab1EDIHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 04:07:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=x4tPMR3zxTrDaJEShv5SDAwD0lMGDKMQiVP27vi+W8aStCRnCEALAyUk+DfSwtnfB1
         SPRfp5goxmkX6eqADVI9hCCgNFgrqpwNBQfWuYLZu4RZvx2T7DUt/jh9f52MT8BxkfLU
         igvkLin+7o7NPgnQKAZ7drwvHIycuwDOAnOD0=
Message-ID: <4DC1094A.7060903@gmail.com>
Date: Wed, 04 May 2011 16:07:38 +0800
From: microcai <microcaicai@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110402 Thunderbird/3.1.9
MIME-Version: 1.0
To: Belisko Marek <marek.belisko@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-sound@vger.kernel.org
Subject: Re: [bug] ASoC uda134x not working for me, and udev crashed at startup
References: <4DBE5B8E.7010109@gmail.com>	<BANLkTinK7bDbwTvsWfxE8w6sPLC--1TUsQ@mail.gmail.com>	<BANLkTi=yeYsHN5pzW7WV5eskVqaC1m1FWw@mail.gmail.com>	<4DBFEB27.3030709@gmail.com> <BANLkTinCNaqTvgqFCpARrcfXE94-iy8gvg@mail.gmail.com>
In-Reply-To: <BANLkTinCNaqTvgqFCpARrcfXE94-iy8gvg@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年05月04日 04:18, Belisko Marek 写道:
> On Tue, May 3, 2011 at 1:46 PM, microcai <microcaicai@gmail.com> wrote:
>>  2011-05-03 17:09, Belisko Marek Wrote:
>>> On Mon, May 2, 2011 at 9:56 AM, Belisko Marek <marek.belisko@gmail.com> wrote:
>>>> CC also linux-sound mailing list.
>>>>
>>>> On Mon, May 2, 2011 at 9:21 AM, microcai <microcaicai@gmail.com> wrote:
>>>>> Heya,
>>>>>
>>>>> The commit a110f4ef810ee29d810876df725f41d66629733e is not working for
>>>>> me. I'm using an TQ2440 platform, very similar to mini2440. Only the LCD
>>>>> and LED is the difference. Basically just copy & past from the
>>>>> mach-mini2440.c to mach-tq2440.c. ;)
>>>>>
>>>>> I installed Gentoo on the system, when startup, I got
>>>>>
>>>>> [    1.645000] ALSA device list:
>>>>> [    1.645000]   No soundcards found.
>>>> With this patch you shouldn't see this in boot log. At least it work for me ;)
>>> Did you enable Audio in menuconfig? For mini2440_defconfig audio is not selected
>>> by default. SoC I2S Audio support UDA134X wired to a S3C24XX must be enabled.
>>> Please let us know if it helps.
> Sorry confusing. Which kernel you're using? I use mainline kernel not some
> custom tree. Please use mainline.

It is mainline kernel. With a little path by myself. But it not sound stuff.
