Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab1IVWVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:21:16 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41085 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab1IVWVN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:21:13 -0400
MIME-Version: 1.0
In-Reply-To: <4E7BA605.3020908@t-online.de>
References: <1316018905-4175-1-git-send-email-nlopezcasad@logitech.com>
	<4E77A221.1060909@t-online.de>
	<CAN+gG=EcaMrz2w-cVL-cCwi2NNVJ-NXOpOQpbjyFdCwn5+Bn+w@mail.gmail.com>
	<4E7BA605.3020908@t-online.de>
Date: Fri, 23 Sep 2011 00:21:11 +0200
Message-ID: <CAN+gG=EaHAW504Bi7PDtdsCT0pfs0=BAW5Pt+pSKkkyS5DXfhw@mail.gmail.com>
Subject: Re: [PATCH v5 1/1] HID: Add full support for Logitech Unifying receivers
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: =?ISO-8859-1?Q?Richard_Sch=FCtz?= <r.schtz@t-online.de>
Cc: Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, rtitmuss@logitech.com, ogay@logitech.com,
        jzanone@logitech.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 23:17, Richard Schütz <r.schtz@t-online.de> wrote:
> Am 22.09.2011 22:48, schrieb Benjamin Tissoires:
>>
>> Hi Richard,
>>
>> here, you'll find a small C program that allows you to do a pairing of
>> a new device to a receiver.
>
> Thanks.
>
> Could you also add the possibility to remove a pairing? It would be nice if
> the program would print the product name of device detected during the
> pairing process, too.

mmm... this would be more complicated:
- the first problem is a NDA and political one. As I worked in
Logitech, I had access to some internal (confidential) documentation.
I was able to release this piece of code as it can be easily retrieved
by adding a spy on the usb stack when doing the pairing on windows.
Discovering the command that removes devices is not so easy (to my
mind), thus, I can not give it right now.  Please note that I asked
them if I could release this magic sequence, and it went quite high in
the hierarchy (but this piece of code has nothing to do with Logitech,
just to be clear).
- the second problem is more a technical one. The removal of the
device would require you two know which device you want to remove. So
it would require the ability to know all the different devices and
their pairing number. This information shows up somewhere in the log
but there is no way to ask the receiver for this information with the
current status of the driver (without knowing internal commands).
Getting it from the list of devices would be quite complicated
depending on the number of receivers you have plugged, etc...
- Obtaining the name of the device can not be retrieved at the moment
without knowing the different commands to send to the device. As it's
confidential Logitech, I can not give them to you unless someone else
does the retro-engineering.

So, to sum up, I agree this would be better, but today, this has to be
done by someone else, either officially at Logitech, or by someone not
related to Logitech that does the retro-engineering.

>
> I think the tool should be distributed somewhere officially. There are
> probably a lot of people, who would use the Unifying feature under Linux,
> but don't read the mailing lists.

I really don't have the time to do it. If somebody else want to pack
it and publish it, I'm fine with it. I just gave this piece of code on
this channel in order to target skilled persons that are able to
compile a C file, and to run it from a shell. Then, if someone wants
to do a gui or anything else (the important part in the code is the
magic sequence), it's ok for me.

Sorry for not being able to do more.
Benjamin

>
> --
> Regards,
> Richard Schütz
>
