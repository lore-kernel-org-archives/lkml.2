Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab1CJL73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 06:59:29 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39483 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab1CJL7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 06:59:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=tm8A9n+2BxVPdhSRp/UqxBwzBjUdh5Al44et+S1uy4G60srfZXz2+WOLp1rr9xGFpC
         QxuYm+8WWxDLd89HWl2d8HcCV/rg6mDRi88JxUPFTMDDeCa2T0bPmUj+YrefiBy3G/mi
         WdfygvpNfBgIdjzlSRWs4zTJi+w/XOwWAZ0ag=
From: Wang Lei <f3d27b@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: [BUG] Fans keep running, first found since v2.6.38-rc7
References: <4d774c85.20f98e0a.2695.73ed@mx.google.com>
	<201103092125.43950.rjw@sisk.pl>
	<4d780a2f.231a8f0a.3b01.ffffa228@mx.google.com>
	<201103100106.36678.rjw@sisk.pl>
Date: Thu, 10 Mar 2011 19:59:35 +0800
In-Reply-To: <201103100106.36678.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Thu, 10 Mar 2011 01:06:36 +0100")
Message-ID: <4d78bd1c.231a8f0a.2e76.ffffcb63@mx.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Thursday, March 10, 2011, Wang Lei wrote:
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> 
>> > On Wednesday, March 09, 2011, Wang Lei wrote:
>> >> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> >> 
>> >> >
>> >> > There was only one commit in that area since 2.6.38-rc6, but it shouldn't
>> >> > affect the functionality this way.
>> >> >
>> >> > Is yout thermal management controlled by ACPI?
>> >> >
>> >> > Rafael
>> >> 
>> >> Thanks for your reply!
>> >> 
>> >> How could I know that?
>> >
>> > What does "ls -l /sys/class/thermal/cooling_device0/device" say?
>> >
>> > Rafael
>> 
>> [~]$ ls -l /sys/class/thermal/cooling_device0/device
>> lrwxrwxrwx 1 root root 0 Mar 10 07:13 /sys/class/thermal/cooling_device0/device -> ../../../LNXSYSTM:00/device:47/PNP0C0B:00
>> [~]$
>
> That's ACPI.
>
> I don't know, however, which change might cause the problem to happen.
>
> Can you bisect the commits between 2.6.38-rc6 and -rc7 to find the one that
> introduced the issue?
>
> Rafael
OK, I'll try.

-- 
Regards,
Lei
