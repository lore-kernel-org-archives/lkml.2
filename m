Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab2DUJMM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 05:12:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58293 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab2DUJMJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 05:12:09 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzjxrOGejBoMNbQxN=tri08ZZVG9DM3mA-3_uU+pMumtA@mail.gmail.com>
References: <CADDKRnALwHa=QteDDcMxBU24rfbKoTOGX=iTcfeE7=M7a+NFcw@mail.gmail.com>
	<CADDKRnAhqi-fwFrr85QC-ZP2g0=_ZSb__jEbZqAekCKXs2CtCg@mail.gmail.com>
	<CADDKRnDJ_u7FkOHPDr0kJ+mh4k06wv2imVh8DV=GzDUQiKEWQw@mail.gmail.com>
	<CAJyhjX0QMf7FcDfx+KDggF7avBnRFcGX6KWy6hJZ_p=ceTFh+g@mail.gmail.com>
	<CA+55aFzjxrOGejBoMNbQxN=tri08ZZVG9DM3mA-3_uU+pMumtA@mail.gmail.com>
Date: Sat, 21 Apr 2012 11:12:08 +0200
Message-ID: <CADDKRnDM_=6XfH2c-3z9umeZcLX1i=6XRRAUS9nyV8D0W3fB7Q@mail.gmail.com>
Subject: Re: [v3.4-rc] regression: reboot not working
From: =?ISO-8859-1?Q?J=F6rg_Otte?= <jrg.otte@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sergio Correia <lists@uece.net>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        hpa@zytor.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, for me it works.
I'm now now up to 6be5ceb02e98eaf6cfc4f8b12a896d04023f340d VM: add
"vm_mmap()" helper function

Thanks, Jörg

Am 20. April 2012 20:29 schrieb Linus Torvalds <torvalds@linux-foundation.org>:
> Since nothing ever happened on this, and since the original bugzilla
> entry that caused the commit indicates that there were other
> workarounds for the problem, I have reverted the offending commit in
> my tree.
>
> Jörg, can you please verify that current -git works for you again?
>
>                   Linus
>
> On Wed, Apr 18, 2012 at 9:12 AM, Sergio Correia <lists@uece.net> wrote:
>> On Wed, Apr 18, 2012 at 12:00 PM, Jörg Otte <jrg.otte@googlemail.com> wrote:
>>> 9 days and still no response. Maybe I addressed the wrong person(s).
>>> I Cc to Linus.
>>>
>>> Who can help with this topic?
>>>
>>
>> CC'ing linux-acpi.
>>
>>> Thanks, Joerg
>>>
>>>
>>>
>>> Am 14. April 2012 12:46 schrieb Jörg Otte <jrg.otte@googlemail.com>:
>>>> It's now bisected:
>>>>
>>>> cf450136bfde77c7f95065c91bffded4aa7fa731   ACPI: ignore FADT reset-reg-sup flag
>>>>
>>>> Thanks, Joerg
>>>>
>>>>
>>>> Am 9. April 2012 17:19 schrieb Jörg Otte <jrg.otte@googlemail.com>:
>>>>> Hi,
>>>>>
>>>>> On reboot it shuts down as normal.
>>>>> The last lines displayed are:
>>>>>
>>>>>>.
>>>>>>Unmounting temporary filesystems.. [OK]
>>>>>>Deactivating swap...               [OK]
>>>>>>Unmounting local filesystems...    [OK]
>>>>>>Will now restart
>>>>>>    Restarting system
>>>>>
>>>>> Then I hear it accessing the cd-drive, but then
>>>>> it's being stuck.
>>>>>
>>>>> v3.3 was ok. HW is a Thinkpad T43.
>>>>>
>>>>> Please Cc me I'm not subscribed.
>>>>>
>>>>> Thanks,Joerg
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
