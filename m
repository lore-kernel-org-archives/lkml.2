Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933392Ab2KEWLB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 17:11:01 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64734 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933111Ab2KEWKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 17:10:55 -0500
MIME-Version: 1.0
In-Reply-To: <1888439.VY5iAKy5E9@vostro.rjw.lan>
References: <1351128963-10347-1-git-send-email-ying.huang@intel.com>
 <CAErSpo6Q9DGwBJNCY5g3gGVPMCngv6pfLXB6TfiFu3gyLiNp7Q@mail.gmail.com> <1888439.VY5iAKy5E9@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 5 Nov 2012 15:10:34 -0700
Message-ID: <CAErSpo4Rfk2VBGdqprcVEBWUvi_OZ2E6+vzGznY9XetUoGCkxA@mail.gmail.com>
Subject: Re: [BUGFIX] PCI/PM: Fix proc config reg access for D3cold and bridge suspending
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 2:25 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, November 02, 2012 10:38:43 AM Bjorn Helgaas wrote:
>> On Wed, Oct 24, 2012 at 7:36 PM, Huang Ying <ying.huang@intel.com> wrote:
>> > In
>> >
>> >   https://bugzilla.kernel.org/show_bug.cgi?id=48981
>> >
>> > Peter reported that /proc/bus/pci/??/??.? does not works for 3.6.
>> > This is This is because the device configuration space registers will
>> > be not accessible if the corresponding parent bridge is suspended or
>> > the device is put into D3cold state.
>> >
>> > This is the same as /sys/bus/pci/devices/0000:??:??.?/config access
>> > issue.  So the function used to solve sysfs issue is used to solve
>> > this issue.
>> >
>> > Cc: stable@vger.kernel.org
>> > Reported-by: Peter <lekensteyn@gmail.com>
>>
>> Is this bug the same as the one originally reported by Forrest Loomis
>> (original reporter of bug 48981)?  And
>> https://bugzilla.kernel.org/show_bug.cgi?id=49031, reported by Micael
>> Dias (Rafael marked 49031 as a duplicate of 48981)?
>>
>> If so, I'll mention Forrest and Micael and bug 49031 here as well.
>
> No, it's not.  That one turned out to be a duplicate of bko#48981.

I applied this to my for-linus branch as v3.7 material.  Thanks!
