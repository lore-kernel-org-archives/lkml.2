Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371Ab0E0IFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 04:05:21 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39083 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab0E0IFK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 04:05:10 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimcPZTZYH4fDxX0xlLxMvtl87FDOEP_hdaztFYJ@mail.gmail.com>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	<201005242049.18920.rjw@sisk.pl>
	<87wrusvrqe.fsf@deeprootsystems.com>
	<201005250138.16293.rjw@sisk.pl>
	<1274863655.5882.4875.camel@twins>
	<AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com>
	<1274867106.5882.5090.camel@twins>
	<20100526120242.5c9b73ad@schatten.dmk.lab>
	<AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com>
	<20100526133721.602633b2@schatten.dmk.lab>
	<AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com>
	<20100526142430.327ccbc4@schatten.dmk.lab>
	<20100526141612.3e2e0443@lxorguk.ukuu.org.uk>
	<AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com>
	<AANLkTimcPZTZYH4fDxX0xlLxMvtl87FDOEP_hdaztFYJ@mail.gmail.com>
Date: Thu, 27 May 2010 01:05:08 -0700
Message-ID: <AANLkTilVu_EFAIN5owarAh-2pDomVZUvLsO_XLP4ISTu@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Vitaly Wool <vitalywool@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/27 Vitaly Wool <vitalywool@gmail.com>:
> 2010/5/27 Arve Hjønnevåg <arve@android.com>:
>> On Wed, May 26, 2010 at 6:16 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>>> Really, what are you getting at? Do you deny that there are programs,
>>>> that prevent a device from sleeping? (Just think of the bouncing
>>>> cows app)
>>>>
>>>> And if you have two kernels, one with which your device is dead after 1
>>>> hour and one with which your device is dead after 10 hours. Which would
>>>> you prefer? I mean really... this is ridiculous.
>>>
>>> The problem you have is that this is policy. If I have the device wired
>>> to a big screen and I want cows bouncing on it I'll be most upset if
>>> instead it suspends.
>>
>> We never suspend when the screen is on. If the screen is off, I would
>> not be upset if it suspends.
>
> That's /wrong/. What if you have an active download ongoing when the
> screen is off? This ugly simplistic approach is one of the worst
> things in Android.

On android we have code that blocks suspend while downloading. On
non-android systems I have used if the download has not finished by
the time the auto-sleep timeout kicks in, the system will suspend and
the download halts.

-- 
Arve Hjønnevåg
