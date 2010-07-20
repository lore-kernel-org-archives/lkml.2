Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738Ab0GTV0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 17:26:23 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:63639 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932597Ab0GTV0W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 17:26:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=StAOFE6E51DzUNrqfFlHg8+88S1maFjP8Pr97E3u1PXhHDRqwbx1QhsxszVFumg0LK
         NoPx7Ht1oT/8u/4VoUwqwYx/OFQFtUP72U57smkNh26oZOsKWoMFENz6w8xLtIYw3etN
         UvKz0I/Bi1U5GDl5WTbMKOGJjuYdawmsiIUFA=
MIME-Version: 1.0
In-Reply-To: <174700d6e5f486cdbc52940e0c4056ba.squirrel@thechecks.ca>
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
Date: Tue, 20 Jul 2010 14:26:20 -0700
Message-ID: <AANLkTimi37MwPP5vXeRlyeqF5vdEIxX2092f83pbxFi8@mail.gmail.com>
Subject: Re: Drives missing at boot
From: Mark Knecht <markknecht@gmail.com>
To: Paul Check <paul@thechecks.ca>
Cc: Tejun Heo <tj@kernel.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 2:19 PM, Paul Check <paul@thechecks.ca> wrote:
> I missed your hardware. I have an ASUS PT 6 Deluxe V2 board with 4 drives.
> I think they are 1TB each, Seagate SATA drives.  P
>

What processor? I've got the Core i7-980X. I've wondered if this
problem showed up for me because possibly the 12 thread processor
moves through some part of boot setup pretty quickly.

Mine is an Asus Rampage II Extreme with five 500GB drives.

Whatever the reason great thanks to Tejun for fixing it. I keep
wanting to add an 'r' to his last name to get 'Hero'!

Cheers,
Mark
