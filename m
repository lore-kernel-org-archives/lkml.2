Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab1EQFEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 01:04:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61614 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab1EQFEx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 01:04:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SdcU3wsYKvf6rXwqIY8VqBYZ7P247JTGQhFVg3tr1PCSNhPJ+HATypewu8F+UenIuN
         JRFVsEj7p+iTtuhu9n5zeHhP/3Zz1C3bu0F4b9YG6qux6+MtzEfxrl/7dj6APOe9k8Da
         HNWz8fp1fl4dy5O029NjHbs2wP4Un9BnuBV5s=
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <20110511225540.GA3492@suse.de>
References: <1305100723-29161-1-git-send-email-myungjoo.ham@samsung.com>
	<1305100723-29161-3-git-send-email-myungjoo.ham@samsung.com>
	<20110511225540.GA3492@suse.de>
Date: Tue, 17 May 2011 14:04:52 +0900
X-Google-Sender-Auth: ZJm6I7r4uwGLVs9KOHOLINrxK-g
Message-ID: <BANLkTik__9G-DuSsT_kAc69d+5g8xcVyFg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] PM / DEVFREQ: add sysfs interface (including user tickling)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Mark Brown <broonie@sirena.org.uk>,
        Jiejing Zhang <kzjeef@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Colin Cross <ccross@google.com>, Nishanth Menon <nm@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <len.brown@intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 7:55 AM, Greg KH <gregkh@suse.de> wrote:
> On Wed, May 11, 2011 at 04:58:43PM +0900, MyungJoo Ham wrote:
>> 1. System-wide sysfs interface
>> - tickle_all  R: number of tickle_all execution
>>               W: tickle all devfreq devices
>> - min_interval        R: devfreq monitoring base interval in ms
>> - monitoring  R: shows whether devfreq monitoring is active or
>>   not.
>>
>> 2. Device specific sysfs interface
>> - tickle      R: number of tickle execution for the device
>>               W: tickle the device
>
> Any sysfs file change/addition/removal needs to have a
> Documentation/ABI/ entry as well.  Please add that to this patch instead
> of burying it in the changelog entry, where no one will be able to find
> it in the future.
>
> thanks,
>
> greg k-h
>

Sure, I'll add Documentation/ABI/testing/* entries.

However, would it be appropriate for "1. System-wide sysfs interface"
to be in "sysfs-class-power" and for "2. Device specific sysfs
interface" to be in "sysfs-devices-devfreq"?

System-wide sysfs interface is in /sys/class/power/devfreq/* and
Device specific sysfs interface is in /sys/...DEVICE.../devfreq/* .

Thank you.


- MyungJoo
-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
