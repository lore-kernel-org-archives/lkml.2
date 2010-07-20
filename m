Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750892Ab0GTEAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 00:00:06 -0400
Received: from d72-38-7-254.commercial1.cgocable.net ([72.38.7.254]:2442 "EHLO
	max" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757341Ab0GTEAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 00:00:04 -0400
X-Greylist: delayed 2733 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Jul 2010 00:00:04 EDT
Message-ID: <7141c88bc8c27f26c2187252c0594318.squirrel@thechecks.ca>
In-Reply-To: <4C44BD42.3030904@kernel.org>
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
Date: Mon, 19 Jul 2010 23:14:25 -0400
From: "Paul Check" <paul@thechecks.ca>
To: "Tejun Heo" <tj@kernel.org>
Cc: "Mark Knecht" <markknecht@gmail.com>,
        "Linux Kernel List" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
User-Agent: SquirrelMail/1.4.20
MIME-Version: 1.0
X-Priority: 3 (Normal)
Importance: Normal
X-SA-Exim-Connect-IP: 72.38.7.254
X-SA-Exim-Mail-From: paul@thechecks.ca
Subject: Re: Drives missing at boot
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on max)
X-bounce-key: openstreet.com-1;paul@thechecks.ca;1279598404;0235d49a;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Tejun: I guess this is the same patch that you sent me to fix my issue
with missing drives.  Good news: I've been through about 10 reboots now
and no problems.  Based on my prior experience, I'd say with the old
setup, 10 clean boots in a row was probably less than a 1% event.  So, it
seems that this has fixed my problem.

Thanks!

Regards, Paul

> Hello,
>
> On 07/19/2010 09:31 PM, Mark Knecht wrote:
>>    With about 10-12 day of testing, 1-2 boots/day, I've not had a
>> single boot failure since adding the patch. Only twice has it said
>> tries=2. Every other time it's tries=1. The machine seems to work fine
>> either way.
>
> Hmmm... can you please test the attached patch instead?  It seems
> likely that the root cause is not flakiness of SIDPR but incorrect
> locking in libata EH code.
>
> Thanks.
>
> --
> tejun
>


