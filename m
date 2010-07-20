Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761569Ab0GTUwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:52:12 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56589 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758581Ab0GTUwJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:52:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BUDwPxBXON+PIINnCN1iJccPG3peNGaLupg6Dq0MqABMlSgi/M4NB+zMn1gff08Li4
         raAYxIBgtwefalqsT60Rzhl4dO/dWI5T+9oqBNqVAZbQmKfJLnbDY1jlhLTZA9QgbBxQ
         IniR/7aQw+PfFYjIPcPRo2UKVLxfrA4CBugkQ=
MIME-Version: 1.0
In-Reply-To: <7141c88bc8c27f26c2187252c0594318.squirrel@thechecks.ca>
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
Date: Tue, 20 Jul 2010 13:52:07 -0700
Message-ID: <AANLkTilIZ91tPHcr8JLl0MbO4CjUX3HeXq4lCbZPRggi@mail.gmail.com>
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

On Mon, Jul 19, 2010 at 8:14 PM, Paul Check <paul@thechecks.ca> wrote:
> Hey Tejun: I guess this is the same patch that you sent me to fix my issue
> with missing drives.  Good news: I've been through about 10 reboots now
> and no problems.  Based on my prior experience, I'd say with the old
> setup, 10 clean boots in a row was probably less than a 1% event.  So, it
> seems that this has fixed my problem.
>
> Thanks!
>
> Regards, Paul
>

Hey Paul. Glad it worked for you as it did for me.

Was your hardware in any way similar to mine?

- Mark
