Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab0H0SL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 14:11:57 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:52720 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab0H0SLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 14:11:55 -0400
Subject: Re: System time drifts when processor idle.
From: john stultz <johnstul@us.ibm.com>
To: jean-philippe francois <jp.francois@cynove.com>
Cc: Lin Ming <lin@ming.vg>, venki@google.com, "H. Peter Anvin" <hpa@zytor.com>,
        linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        jslaby@suse.cz
In-Reply-To: <AANLkTikWTLeDLbWWi-LJDD5SRAFN60v5065Vc_wGoY5N@mail.gmail.com>
References: <AANLkTi=ivkOHRYwLy5FDg3RnK18+opjGd9XsxC7yZqi7@mail.gmail.com>
	 <AANLkTik0ZGs3i_mHtB0s6iT6X0cLgxMjRN7Hi9FK_ZLF@mail.gmail.com>
	 <AANLkTikTF9uvKw+48_jJKLAwqp7MJnypvvUsHN3qQ58+@mail.gmail.com>
	 <AANLkTin80q4tGPZ1FefWCUMmhpNKj3_-KZZB12gZvwSA@mail.gmail.com>
	 <AANLkTin5cLQG9ApxhCs92Twm958MP0J+u4GdBysJ3aNk@mail.gmail.com>
	 <AANLkTikWTLeDLbWWi-LJDD5SRAFN60v5065Vc_wGoY5N@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Aug 2010 11:11:48 -0700
Message-ID: <1282932708.1946.8.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-27 at 16:12 +0200, jean-philippe francois wrote:
> My Timekeeping bug is still present, here is an updated script and log.
> I am willing to make test, but I don't know what kind of debugging
> info is needed.
>
> cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> hpet acpi_pm 
> cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> hpet

Huh. hpet was not what I would have expected.


So first, two experiments: 

1) Does booting with "clock=acpi_pm" cause the issue to disappear?

2) Does booting with "nohz=off" cause the issue to disappear?


Venkatesh: You have any experience with HPETs that halt in idle?

thanks
-john


