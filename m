Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966735Ab0GSUkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 16:40:47 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:38643 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966721Ab0GSUkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 16:40:45 -0400
Message-ID: <4C44B840.5090605@fusionio.com>
Date: Mon, 19 Jul 2010 14:40:32 -0600
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Mike Snitzer <snitzer@gmail.com>
CC: Tino Keitel <tino.keitel@tikei.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, "jgarzik@pobox.com" <jgarzik@pobox.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH[RFC] Quirk macbook pro 6,2 into ahci mode
References: <4C4325E0.5020407@fusionio.com>	<20100718184243.GA4062@srcf.ucam.org>	<4C436566.8060609@fusionio.com>	<20100719054027.GA30246@mac.home>	<4C44741D.5010409@fusionio.com>	<20100719155353.GA10248@mac.home>	<4C447586.4030004@fusionio.com> <AANLkTilFL_Zy00aimM8NrdjHL5c2zvfo8yeNjwhW356H@mail.gmail.com>
In-Reply-To: <AANLkTilFL_Zy00aimM8NrdjHL5c2zvfo8yeNjwhW356H@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2010 11:23 AM, Mike Snitzer wrote:
> On Mon, Jul 19, 2010 at 11:55 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>> On 07/19/2010 09:53 AM, Tino Keitel wrote:
>>> On Mon, Jul 19, 2010 at 09:49:49 -0600, Jens Axboe wrote:
>>>
>>> [...]
>>>
>>>> Great! That sounds way better. DO you have a pointer to grub-efi? I'm
>>>> finding some grub2 efi stuff with google, just want to make sure that is
>>>> it. A grub 0.9x with efi would be preferable, I find grub2 to be horrible
>>>> to work with in general...
>>>
>>> With grub-efi I meant the EFI support in grub2. AFAIK grub 0.9x never
>>> supported EFI.
>>>
>>> What information do you need?
>>
>> Just that, if there was some special grub 0.9x efi variant or whether
>> you meant grub2 when you said grub-efi.
> 
> Fedora's grub 0.9x has efi support.
> 
> But that efi support hasn't been propagated to all the other distros
> since grub 0.9x really doesn't have an upstream.

This is Fedora 13. What magic do I need to enable the EFI grub bits
then?

-- 
Jens Axboe

