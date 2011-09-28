Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab1I1VZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 17:25:42 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61245 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab1I1VZk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 17:25:40 -0400
MIME-Version: 1.0
In-Reply-To: <D3E37531-860E-415F-B2B9-58CEBB4E10A3@enac.fr>
References: <1316617015-11648-1-git-send-email-benjamin.tissoires@gmail.com>
	<alpine.LNX.2.00.1109261419330.13109@pobox.suse.cz>
	<20110926144635.GA6921@polaris.bitmath.org>
	<alpine.LNX.2.00.1109261644250.24692@pobox.suse.cz>
	<D3E37531-860E-415F-B2B9-58CEBB4E10A3@enac.fr>
Date: Wed, 28 Sep 2011 23:25:38 +0200
X-Google-Sender-Auth: 8dU2gUju7ditN7riZjgG-86Yghk
Message-ID: <CAN+gG=HWJ0tXvS8nbmv4u0CyB6tQo36xnhXE0xoRYjpdm2h2NA@mail.gmail.com>
Subject: Re: [PATCH 0/2] autodetection of multitouch devices
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
Cc: Jiri Kosina <jkosina@suse.cz>, Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        USB list <linux-input@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 22:32, Stéphane Chatty <chatty@enac.fr> wrote:
>
> Le 26 sept. 2011 à 16:47, Jiri Kosina a écrit :
>
>> On Mon, 26 Sep 2011, Henrik Rydberg wrote:
>>
>>>>> These two patches finally enable the kernel to handle multitouch devices correctly.
>>>>> If a device presents in its report descriptors the usage Contact ID, then it is considered as
>>>>> a multitouch device and handled by hid-multitouch.
>>>>
>>>> Hi Banjamin,
>>>>
>>>> thanks a lot for working on this. I have now queued the patches in my
>>>> tree.
>>>
>>> Hi Benjamin,
>>>
>>> Late as it seems, here are a couple of questions:
>>>
>>> 1. How was this tested? By removing all white-listed devices in
>>> hid-multitouch.c to see if the usual suspects are still picked up?

Well, nearly all the devices that has been included since March passed
the first patch (I had it in my queue since a long time).
For now, only Stantum products are known to not work with this patch
if we remove them from hid_have_special_driver.

As for the blacklist problem, we also know that this is not very
beautiful, but we are working on a better solution. For the moment, it
just allows people to have their device working out of the box
(crossing fingers).

Cheers,
Benjamin


>>
>> If we didn't have full test coverage (which I suppose to be the case), we
>> can still revert to the old method after the merge window if there reports
>> that this broke things on particular devices.
>>
>> Do you guys at least have report descriptor dumps from most of the
>> supported devices?
>
>
> Yes, we have report descriptors for about 20-30 different models now, and about 10 actual devices for testing purposes. Unfortunately, this still does not tell us exactly how all these devices manage to work with the same Win 7 driver, given their diversity. We are getting close, but just not yet.
>
> BTW we gladly accept to receive sample panels from vendors, this usually ensures fast support. Additionally, the panels are then reused by ENAC students in their projects, so this stimulates the market of multitouch devices in aviation :-)
>
> Cheers,
>
> St.
>
>
>
