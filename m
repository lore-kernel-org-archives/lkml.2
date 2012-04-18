Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab2DRQAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 12:00:08 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42388 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab2DRQAE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 12:00:04 -0400
MIME-Version: 1.0
In-Reply-To: <CADDKRnAhqi-fwFrr85QC-ZP2g0=_ZSb__jEbZqAekCKXs2CtCg@mail.gmail.com>
References: <CADDKRnALwHa=QteDDcMxBU24rfbKoTOGX=iTcfeE7=M7a+NFcw@mail.gmail.com>
	<CADDKRnAhqi-fwFrr85QC-ZP2g0=_ZSb__jEbZqAekCKXs2CtCg@mail.gmail.com>
Date: Wed, 18 Apr 2012 18:00:01 +0200
Message-ID: <CADDKRnDJ_u7FkOHPDr0kJ+mh4k06wv2imVh8DV=GzDUQiKEWQw@mail.gmail.com>
Subject: Re: [v3.4-rc] regression: reboot not working
From: =?ISO-8859-1?Q?J=F6rg_Otte?= <jrg.otte@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>, hpa@zytor.com, torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

9 days and still no response. Maybe I addressed the wrong person(s).
I Cc to Linus.

Who can help with this topic?

Thanks, Joerg



Am 14. April 2012 12:46 schrieb Jörg Otte <jrg.otte@googlemail.com>:
> It's now bisected:
>
> cf450136bfde77c7f95065c91bffded4aa7fa731   ACPI: ignore FADT reset-reg-sup flag
>
> Thanks, Joerg
>
>
> Am 9. April 2012 17:19 schrieb Jörg Otte <jrg.otte@googlemail.com>:
>> Hi,
>>
>> On reboot it shuts down as normal.
>> The last lines displayed are:
>>
>>>.
>>>Unmounting temporary filesystems.. [OK]
>>>Deactivating swap...               [OK]
>>>Unmounting local filesystems...    [OK]
>>>Will now restart
>>>    Restarting system
>>
>> Then I hear it accessing the cd-drive, but then
>> it's being stuck.
>>
>> v3.3 was ok. HW is a Thinkpad T43.
>>
>> Please Cc me I'm not subscribed.
>>
>> Thanks,Joerg
