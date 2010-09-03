Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab0ICMXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 08:23:38 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54740 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab0ICMXe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 08:23:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Jd7yA8uXvmL/gD1Mg8++JxNDP6IDiSxoxnWDTkFJXqoRAocMJrR8yewez067atIdCz
         O1xfi/MsMAxJp3CSG7QAztRgLYSaBhE7FLER46asoWSbmsci52J6oXFOG8Y8BSA3HoAx
         dUOWo1C58XMCQQ/cXqJYmPofWTZG45lRSlHRs=
MIME-Version: 1.0
In-Reply-To: <1282932708.1946.8.camel@work-vm>
References: <AANLkTi=ivkOHRYwLy5FDg3RnK18+opjGd9XsxC7yZqi7@mail.gmail.com>
	<AANLkTik0ZGs3i_mHtB0s6iT6X0cLgxMjRN7Hi9FK_ZLF@mail.gmail.com>
	<AANLkTikTF9uvKw+48_jJKLAwqp7MJnypvvUsHN3qQ58+@mail.gmail.com>
	<AANLkTin80q4tGPZ1FefWCUMmhpNKj3_-KZZB12gZvwSA@mail.gmail.com>
	<AANLkTin5cLQG9ApxhCs92Twm958MP0J+u4GdBysJ3aNk@mail.gmail.com>
	<AANLkTikWTLeDLbWWi-LJDD5SRAFN60v5065Vc_wGoY5N@mail.gmail.com>
	<1282932708.1946.8.camel@work-vm>
Date: Fri, 3 Sep 2010 14:23:32 +0200
X-Google-Sender-Auth: kQGaECIxxEGq5Ss6VgD7GEHGpK0
Message-ID: <AANLkTina8xAwnGVuPKywsf1qEzpu+rWNbv7JjqAgLqp1@mail.gmail.com>
Subject: Re: System time drifts when processor idle.
From: jean-philippe francois <jp.francois@cynove.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Lin Ming <lin@ming.vg>, venki@google.com, "H. Peter Anvin" <hpa@zytor.com>,
        linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        jslaby@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/27 john stultz <johnstul@us.ibm.com>:
> On Fri, 2010-08-27 at 16:12 +0200, jean-philippe francois wrote:
>> My Timekeeping bug is still present, here is an updated script and log.
>> I am willing to make test, but I don't know what kind of debugging
>> info is needed.
>>
>> cat /sys/devices/system/clocksource/clocksource0/available_clocksource
>> hpet acpi_pm
>> cat /sys/devices/system/clocksource/clocksource0/current_clocksource
>> hpet
>
> Huh. hpet was not what I would have expected.
>
>
> So first, two experiments:
>
> 1) Does booting with "clock=acpi_pm" cause the issue to disappear?
>

Hi,

The same bug happens with clock=acpi_pm.
My apologies for a previous mail where I said it was not hapenning with acpi_pm.

With both clock, the timekeeping gap augments by amount of 5 minutes.

Jean-Philippe François
