Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab1ERAnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 20:43:11 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36675 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756465Ab1ERAnK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 20:43:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mFk8CwLzWOKcQZVAdgPqeoSz59xGcxgJyRYiQCUAhyKMDim2jC6c78LKBAWbC3EU/5
         6Ct6EYxAX7HOKYSC+FCqdu6Y6pSbvURd+lx8VDn9iDsZ7147BWhEHglabVESGhL21Icq
         5c8dvaQgN7+r5B9pbATDwYG9F7zTQdm2YnlB8=
MIME-Version: 1.0
In-Reply-To: <201105180041.57723.rjw@sisk.pl>
References: <1305100723-29161-1-git-send-email-myungjoo.ham@samsung.com>
	<20110511225540.GA3492@suse.de>
	<BANLkTik__9G-DuSsT_kAc69d+5g8xcVyFg@mail.gmail.com>
	<201105180041.57723.rjw@sisk.pl>
Date: Wed, 18 May 2011 09:43:08 +0900
Message-ID: <BANLkTin+sJeg20BXbOfe7TyDhuDWZqqMMQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] PM / DEVFREQ: add sysfs interface (including user tickling)
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <gregkh@suse.de>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@sirena.org.uk>,
        Jiejing Zhang <kzjeef@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Colin Cross <ccross@google.com>, Nishanth Menon <nm@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <len.brown@intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 7:41 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, May 17, 2011, MyungJoo Ham wrote:
>> On Thu, May 12, 2011 at 7:55 AM, Greg KH <gregkh@suse.de> wrote:
>> > On Wed, May 11, 2011 at 04:58:43PM +0900, MyungJoo Ham wrote:
>> >> 1. System-wide sysfs interface
>> >> - tickle_all  R: number of tickle_all execution
>> >>               W: tickle all devfreq devices
>> >> - min_interval        R: devfreq monitoring base interval in ms
>> >> - monitoring  R: shows whether devfreq monitoring is active or
>> >>   not.
>> >>
>> >> 2. Device specific sysfs interface
>> >> - tickle      R: number of tickle execution for the device
>> >>               W: tickle the device
>> >
>> > Any sysfs file change/addition/removal needs to have a
>> > Documentation/ABI/ entry as well.  Please add that to this patch instead
>> > of burying it in the changelog entry, where no one will be able to find
>> > it in the future.
>> >
>> > thanks,
>> >
>> > greg k-h
>> >
>>
>> Sure, I'll add Documentation/ABI/testing/* entries.
>>
>> However, would it be appropriate for "1. System-wide sysfs interface"
>> to be in "sysfs-class-power" and for "2. Device specific sysfs
>> interface" to be in "sysfs-devices-devfreq"?
>>
>> System-wide sysfs interface is in /sys/class/power/devfreq/* and
>
> Hmm.  Why not to use /sys/power/ that's already there?

Ah.. that was my mistake. I'd put it at /sys/power/devfreq/*.

Thank you for cleaning that up.

>
>> Device specific sysfs interface is in /sys/...DEVICE.../devfreq/* .
>
> Thanks,
> Rafael
>

Cheers!
- MyungJoo
-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
