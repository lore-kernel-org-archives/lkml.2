Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab2KMKaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 05:30:05 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33301 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716Ab2KMKaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 05:30:02 -0500
MIME-Version: 1.0
In-Reply-To: <20121106021200.GC13487@kroah.com>
References: <20120330195823.GA31857@kroah.com> <20121105091118.GA12721@elie.Belkin>
 <20121105101331.GA24688@kroah.com> <1672482.cmtUloFutg@callisto> <20121106021200.GC13487@kroah.com>
From: Rabin Vincent <rabin@rab.in>
Date: Tue, 13 Nov 2012 11:29:21 +0100
X-Google-Sender-Auth: JoEwgsJaGW4ElM_dv-FskFpzCuU
Message-ID: <CAH+eYFC3tB3oHBudF0WpxEDQvxKTMrZB1_V9jhBTBh2x-zFrhQ@mail.gmail.com>
Subject: Re: [regression] Re: [ 049/149] rtc: Disable the alarm in the
 hardware (v2)
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Heinz Wiesinger <HMWiesinger@gmx.at>, Jonathan Nieder <jrnieder@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, John Stultz <john.stultz@linaro.org>,
        Janne Boman <janne.m.boman@gmail.com>, rtc-linux@googlegroups.com,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/6 Greg KH <gregkh@linuxfoundation.org>:
> Working with the developers involved would be great.  Anyone have any
> patches that Heinz could test?

I've little idea why just disabling the RTC alarm would cause the system not
to shutdown.  Perhaps someone who understands ACPI or rtc-cmos.c can
shed some light?

For linux-acpi, the acpidump is linked to from here:
https://lkml.org/lkml/2012/11/5/81
