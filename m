Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090Ab0GTXFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 19:05:22 -0400
Received: from d72-38-7-254.commercial1.cgocable.net ([72.38.7.254]:3219 "EHLO
	max" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933021Ab0GTXFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 19:05:20 -0400
Message-ID: <1bb599bb8a51ff0f13a270470b2f5496.squirrel@thechecks.ca>
In-Reply-To: <AANLkTimi37MwPP5vXeRlyeqF5vdEIxX2092f83pbxFi8@mail.gmail.com>
References: <AANLkTimVkG9TFgyOTTnrztBjqT4JoOzFaP268vWLAAm9@mail.gmail.com>
    <4C2F5ECB.1040505@kernel.org>
    <AANLkTinBn35687znO2_IxI3s1opkXrG2HpCRgsejNbMq@mail.gmail.com>
    <4C2F61AB.9030806@kernel.org>
    <AANLkTilYOT45q8OUJ-_V61_fnYy9HIk6GAv5ZPiomCaT@mail.gmail.com>
    <4C317C04.20500@kernel.org>
    <AANLkTilupyieml9yaWO9BUNPmQQ0g2w1HLWj6R9MwDZf@mail.gmail.com>
    <4C32CE50.6010501@kernel.org>
    <AANLkTikehTO1j6Gd7Y_g32_P6Yg9KB8Z8qwbNJh10aOU@mail.gmail.com>
    <4C341598.6040004@kernel.org>
    <AANLkTik4zkcIyVxwtX8GA1BsQSZaAeODpPlY3mRVBc-4@mail.gmail.com>
    <4C34A1D5.1090202@kernel.org>
    <AANLkTilgQSu3qi7qoTtjnV22r-8Sh1hbDAB_nlPImWNt@mail.gmail.com>
    <4C34B8BE.5080504@kernel.org>
    <AANLkTilDbrA6lLPSOAtA8_4mLNkUZibHweTliqU5jd03@mail.gmail.com>
    <4C44BD42.3030904@kernel.org>
    <7141c88bc8c27f26c2187252c0594318.squirrel@thechecks.ca>
    <AANLkTilIZ91tPHcr8JLl0MbO4CjUX3HeXq4lCbZPRggi@mail.gmail.com>
    <174700d6e5f486cdbc52940e0c4056ba.squirrel@thechecks.ca>
    <AANLkTimi37MwPP5vXeRlyeqF5vdEIxX2092f83pbxFi8@mail.gmail.com>
Date: Tue, 20 Jul 2010 19:05:15 -0400
From: "Paul Check" <paul@thechecks.ca>
To: "Mark Knecht" <markknecht@gmail.com>
Cc: "Paul Check" <paul@thechecks.ca>, "Tejun Heo" <tj@kernel.org>,
        "Linux Kernel List" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
User-Agent: SquirrelMail/1.4.20
MIME-Version: 1.0
X-Priority: 3 (Normal)
Importance: Normal
X-SA-Exim-Connect-IP: 72.38.7.254
X-SA-Exim-Mail-From: paul@thechecks.ca
Subject: Re: Drives missing at boot
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on max)
X-bounce-key: openstreet.com-1;paul@thechecks.ca;1279667120;1dd21426;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, yeah, my processor is the i7 975. That's 4 cores 8 threads, right? 
Yes, nice work Tejun, thanks.  I'll have to run custom kernels until this
gets fed into Debian.  P

> On Tue, Jul 20, 2010 at 2:19 PM, Paul Check <paul@thechecks.ca> wrote:
>> I missed your hardware. I have an ASUS PT 6 Deluxe V2 board with 4
>> drives.
>> I think they are 1TB each, Seagate SATA drives.  P
>>
>
> What processor? I've got the Core i7-980X. I've wondered if this
> problem showed up for me because possibly the 12 thread processor
> moves through some part of boot setup pretty quickly.
>
> Mine is an Asus Rampage II Extreme with five 500GB drives.
>
> Whatever the reason great thanks to Tejun for fixing it. I keep
> wanting to add an 'r' to his last name to get 'Hero'!
>
> Cheers,
> Mark
>


