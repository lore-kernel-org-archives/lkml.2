Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab0GTDIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 23:08:43 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:41318 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757941Ab0GTDIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 23:08:42 -0400
Message-ID: <4C451335.8090406@fusionio.com>
Date: Mon, 19 Jul 2010 21:08:37 -0600
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Mike Snitzer <snitzer@gmail.com>
CC: Tino Keitel <tino.keitel@tikei.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, "jgarzik@pobox.com" <jgarzik@pobox.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "pjones@redhat.com" <pjones@redhat.com>
Subject: Re: using grub.efi on fedora13? [was: Re: [PATCH[RFC] Quirk macbook
 pro   6,2 into ahci mode]
References: <AANLkTil7vGSNZAWeubOuW4Z7tCpjQTxyECm0bVoh7SY5@mail.gmail.com>
In-Reply-To: <AANLkTil7vGSNZAWeubOuW4Z7tCpjQTxyECm0bVoh7SY5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2010 06:47 PM, Mike Snitzer wrote:
> On Mon, Jul 19, 2010 at 4:40 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
>> On 07/19/2010 11:23 AM, Mike Snitzer wrote:
>>> On Mon, Jul 19, 2010 at 11:55 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>>> On 07/19/2010 09:53 AM, Tino Keitel wrote:
>>>>> On Mon, Jul 19, 2010 at 09:49:49 -0600, Jens Axboe wrote:
>>>>>
>>>>> [...]
>>>>>
>>>>>> Great! That sounds way better. DO you have a pointer to grub-efi? I'm
>>>>>> finding some grub2 efi stuff with google, just want to make sure that is
>>>>>> it. A grub 0.9x with efi would be preferable, I find grub2 to be horrible
>>>>>> to work with in general...
>>>>>
>>>>> With grub-efi I meant the EFI support in grub2. AFAIK grub 0.9x never
>>>>> supported EFI.
>>>>>
>>>>> What information do you need?
>>>>
>>>> Just that, if there was some special grub 0.9x efi variant or whether
>>>> you meant grub2 when you said grub-efi.
>>>
>>> Fedora's grub 0.9x has efi support.
>>>
>>> But that efi support hasn't been propagated to all the other distros
>>> since grub 0.9x really doesn't have an upstream.
>>
>> This is Fedora 13. What magic do I need to enable the EFI grub bits
>> then?
> 
> I've never used it.. I was more delivering the message that Fedora's
> grub supports efi ;)
> 
> I found these, but no official fedora installation docs (that I could find):
> http://fedoraproject.org/wiki/Features/EFI
> http://blog.fpmurphy.com/2009/12/using-uefi-duet-to-boot-fedora-12.html
> http://blog.christophersmart.com/2009/07/23/linux-on-an-apple-xserve-efi-only-machine/
> 
> 'man grub.efi' would be awesome but no such luck...
> 
> Cc'ing Peter who should be able to steer you in the right direction.

Thanks for the pointers, I'll take it off list at this point, it's getting somewhat
off topic :-)

-- 
Jens Axboe

