Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab0H1MpN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 08:45:13 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35225 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab0H1MpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 08:45:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=bt0ycQrZaGX8UCbMq8wu3p+obIxXUAy4r6kmkXkr+dK3qo1+vPqWDOvyWEV0etmNl5
         Bxk40oqmXVKHUXLaeRP4L4zkmf6Q+ZelvxBTXTaWLkcG8lD42/jW3tqtN29HGToW/MY9
         6uDJ8tO+uACX9Sv0hvMf6h2DxMNqAtmHaaxJ4=
MIME-Version: 1.0
In-Reply-To: <1282957741.1946.27.camel@work-vm>
References: <AANLkTi=ivkOHRYwLy5FDg3RnK18+opjGd9XsxC7yZqi7@mail.gmail.com>
	<AANLkTik0ZGs3i_mHtB0s6iT6X0cLgxMjRN7Hi9FK_ZLF@mail.gmail.com>
	<AANLkTikTF9uvKw+48_jJKLAwqp7MJnypvvUsHN3qQ58+@mail.gmail.com>
	<AANLkTin80q4tGPZ1FefWCUMmhpNKj3_-KZZB12gZvwSA@mail.gmail.com>
	<AANLkTin5cLQG9ApxhCs92Twm958MP0J+u4GdBysJ3aNk@mail.gmail.com>
	<AANLkTikWTLeDLbWWi-LJDD5SRAFN60v5065Vc_wGoY5N@mail.gmail.com>
	<1282932708.1946.8.camel@work-vm>
	<AANLkTi=8MXx9L0+V-JqXoO5PCWq5EPRW9fqpr913OTyC@mail.gmail.com>
	<1282957741.1946.27.camel@work-vm>
Date: Sat, 28 Aug 2010 14:45:10 +0200
X-Google-Sender-Auth: cGtgFrYjM7cS7c8U6eapUa0LgJ4
Message-ID: <AANLkTinh6E1mjyDK6Oud_tkL409xrsZRDA7gX+uGZ+Pc@mail.gmail.com>
Subject: Re: System time drifts when processor idle.
From: jean-philippe francois <jp.francois@cynove.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Venkatesh Pallipadi <venki@google.com>, Lin Ming <lin@ming.vg>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-acpi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, jslaby@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/28 john stultz <johnstul@us.ibm.com>:

>> > Huh. hpet was not what I would have expected.
>> >
>> >
>> > So first, two experiments:
>> >
>> > 1) Does booting with "clock=acpi_pm" cause the issue to disappear?
>> >

Yes, the problem usually show up quite quickly, and I think I have let
my script run
for a long enough time to say it does not occur with clock=acpi_pm

>> > 2) Does booting with "nohz=off" cause the issue to disappear?
>> >
Not tested yet.

>
> jean-philippe: Is the drift always in 5 minute increments? Can you leave
> it idle for 3 minutes and see a similar 3 minute delay, or is it always
> in units of 5 ?
>
That is interesting !
I think I have always seen 5 minutes or multiples of this delay. I
will try to leave it running for a longer
period of time and come back to you with more results. If you look at
the first message of this thread
(on linux-acpi) the delay is first 5, then 10 minutes.

Thank you for your interest.

Jean-Philippe
