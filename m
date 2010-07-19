Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966588Ab0GSTbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 15:31:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55851 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965813Ab0GSTbs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 15:31:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AZWX9CEEek4CpEZ1DJl2AfwKvTuMD9qmB30B09UIrLXcT/qNdn3WYN545de23heMeq
         5NgOAi2AW8F1QlRB1GeqRtPH6Tz6IaAEmEeaUE08uEKz3xRdRkfZE82VtzJcfo37Og1M
         an5Wnff4xklIBkxTdVygYaofNsrek1zo/tmEQ=
MIME-Version: 1.0
In-Reply-To: <4C34B8BE.5080504@kernel.org>
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
Date: Mon, 19 Jul 2010 12:31:47 -0700
Message-ID: <AANLkTilDbrA6lLPSOAtA8_4mLNkUZibHweTliqU5jd03@mail.gmail.com>
Subject: Re: Drives missing at boot
From: Mark Knecht <markknecht@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 7, 2010 at 10:26 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On 07/07/2010 07:06 PM, Mark Knecht wrote:
>> 4 warm reboots. All 4 said 300 300. However the 4th one only showed an
>> extra attempt at running the patch code with and also showed Tries =
>> 2. I'm attaching boot #1 and boot #4 for now. I've saved them all if
>> you need or just want them.
>>
>> Please note that in all 4 cases all drives were found. Nothing is
>> missing in any test yet after adding these either of these patches.
>>
>> I've not tried cold boots yet. That's next.
>
> Hmm... just in case you're being lucky, please keep an eye on it over
> several days and report the result.  I think all that's necessary is
> slight modification to the resume logic but let's watch a bit first.
>
> Thanks.
>
> --
> tejun
>

Tejun,
   With about 10-12 day of testing, 1-2 boots/day, I've not had a
single boot failure since adding the patch. Only twice has it said
tries=2. Every other time it's tries=1. The machine seems to work fine
either way.

Thanks,
Mark
