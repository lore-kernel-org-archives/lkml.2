Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592Ab0GTOxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 10:53:45 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53908 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758237Ab0GTOxm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 10:53:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=g5sgJ2BuownfCE5tbp6AiIEkjbQa1a0YIBHTVHPNmHGqT4FlWG8E+kDxthubcyYt0r
         zY30D7d+M7BiQKOreV3+FbLch3GncXVdnFafPm/RsiOMCn76yHXMognfaMoN6v75IMGr
         sVm16BuLQb4ingVn03Nu7EJPfJELu83ecPwUA=
MIME-Version: 1.0
In-Reply-To: <4C45AF40.7030800@kernel.org>
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
	<4C45AF40.7030800@kernel.org>
Date: Tue, 20 Jul 2010 07:53:39 -0700
Message-ID: <AANLkTilXlTmTIdRZa5rTDIo6gSZKeU1-CSAskxmRJwtl@mail.gmail.com>
Subject: Re: Drives missing at boot
From: Mark Knecht <markknecht@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Paul Check <paul@thechecks.ca>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 7:14 AM, Tejun Heo <tj@kernel.org> wrote:
> Helo,
>
> On 07/20/2010 05:14 AM, Paul Check wrote:
>> Hey Tejun: I guess this is the same patch that you sent me to fix my issue
>> with missing drives.  Good news: I've been through about 10 reboots now
>> and no problems.  Based on my prior experience, I'd say with the old
>> setup, 10 clean boots in a row was probably less than a 1% event.  So, it
>> seems that this has fixed my problem.
>
> Yeap, it's the same one.  I'm forwarding the patch upstream now but,
> Mark, please let me know the test result.
>
> Thanks.
>
> --
> tejun
>

Tejun,
   I'm traveling but back tonight. I'll try it then.

Thanks,
Mark
