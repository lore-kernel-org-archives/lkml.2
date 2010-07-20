Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210Ab0GTOOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 10:14:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:39941 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154Ab0GTOOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 10:14:35 -0400
Message-ID: <4C45AF40.7030800@kernel.org>
Date: Tue, 20 Jul 2010 16:14:24 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Paul Check <paul@thechecks.ca>
CC: Mark Knecht <markknecht@gmail.com>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: Drives missing at boot
References: <AANLkTimVkG9TFgyOTTnrztBjqT4JoOzFaP268vWLAAm9@mail.gmail.com>    <4C2F5ECB.1040505@kernel.org>    <AANLkTinBn35687znO2_IxI3s1opkXrG2HpCRgsejNbMq@mail.gmail.com>    <4C2F61AB.9030806@kernel.org>    <AANLkTilYOT45q8OUJ-_V61_fnYy9HIk6GAv5ZPiomCaT@mail.gmail.com>    <4C317C04.20500@kernel.org>    <AANLkTilupyieml9yaWO9BUNPmQQ0g2w1HLWj6R9MwDZf@mail.gmail.com>    <4C32CE50.6010501@kernel.org>    <AANLkTikehTO1j6Gd7Y_g32_P6Yg9KB8Z8qwbNJh10aOU@mail.gmail.com>    <4C341598.6040004@kernel.org>    <AANLkTik4zkcIyVxwtX8GA1BsQSZaAeODpPlY3mRVBc-4@mail.gmail.com>    <4C34A1D5.1090202@kernel.org>    <AANLkTilgQSu3qi7qoTtjnV22r-8Sh1hbDAB_nlPImWNt@mail.gmail.com>    <4C34B8BE.5080504@kernel.org>    <AANLkTilDbrA6lLPSOAtA8_4mLNkUZibHweTliqU5jd03@mail.gmail.com>    <4C44BD42.3030904@kernel.org> <7141c88bc8c27f26c2187252c0594318.squirrel@thechecks.ca>
In-Reply-To: <7141c88bc8c27f26c2187252c0594318.squirrel@thechecks.ca>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 20 Jul 2010 14:14:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helo,

On 07/20/2010 05:14 AM, Paul Check wrote:
> Hey Tejun: I guess this is the same patch that you sent me to fix my issue
> with missing drives.  Good news: I've been through about 10 reboots now
> and no problems.  Based on my prior experience, I'd say with the old
> setup, 10 clean boots in a row was probably less than a 1% event.  So, it
> seems that this has fixed my problem.

Yeap, it's the same one.  I'm forwarding the patch upstream now but,
Mark, please let me know the test result.

Thanks.

-- 
tejun
