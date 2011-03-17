Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab1CQGuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 02:50:10 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45487 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab1CQGuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 02:50:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gfuemTVvWfc3pLN7jolyNc74w8QE3X7hB71j/MFxd4DHBmDtAjt2tk2nZC1or0KbTR
         8niUDdlg5kZWa8iRUhNWhZ9AgAj7WCQGdSVaS2v9iyIwCxaJi2rvJ/MvYEwrNZ6eHJZH
         Z8eqyQhr0iCmCc1Mc5OBy1Ehxx94lAC/ZiqMA=
MIME-Version: 1.0
In-Reply-To: <20110316154047.GB21758@ovro.caltech.edu>
References: <20110310070541.27327.52089.sendpatchset@t400s>
	<87d3lriv7e.fsf@rustcorp.com.au>
	<AANLkTi=zjGubKx0vV+hqEYiVFVNTAEoGwxEfL4oprxk8@mail.gmail.com>
	<20110316154047.GB21758@ovro.caltech.edu>
Date: Thu, 17 Mar 2011 15:50:04 +0900
Message-ID: <AANLkTimwt4hvaU0E=7tJx=zUUJKk5dgZDw4tXphj4Ype@mail.gmail.com>
Subject: Re: [PATCH 00/02] virtio: Virtio platform driver
From: Magnus Damm <magnus.damm@gmail.com>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, mst@redhat.com,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 12:40 AM, Ira W. Snyder <iws@ovro.caltech.edu> wrote:
> On Wed, Mar 16, 2011 at 02:17:15PM +0900, Magnus Damm wrote:
>> On Wed, Mar 16, 2011 at 12:46 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> > On Thu, 10 Mar 2011 16:05:41 +0900, Magnus Damm <magnus.damm@gmail.com> wrote:
>> >> virtio: Virtio platform driver
>> >>
>> >> [PATCH 01/02] virtio: Break out lguest virtio code to virtio_lguest.c
>> >> [PATCH 02/02] virtio: Add virtio platform driver
>> >
>> > I have no problem with these patches, but it's just churn until we see
>> > your actual drivers.
>>
>> Well, actually this platform driver is used together with already
>> existing drivers, so there are no new virtio drivers to wait for.
>>
>> The drivers that have been tested are so far:
>>
>> CONFIG_VIRTIO_CONSOLE=y
>> CONFIG_VIRTIO_NET=y
>>
>> At this point there are four different pieces of code working together
>>
>> 1) Virtio platform driver patches (for guest)
>> 2) SH4AL-DSP guest kernel patch
>> 3) ARM UIO driver patches (for host)
>> 4) User space backing code for ARM based on lguest.c
>>
>> These patches in this mail thread are 1), and I decided to brush up
>> that portion and submit upstream because it's the part that is easiest
>> to break out. I intend to post the rest bit by bit over time, but if
>> someone is interested then I can post everything at once too.
>>
>
> I'm very interested in the full series of patches. I want to do
> something similar to talk between two Linux kernels (x86 and PowerPC)
> connected by a PCI bus.

For a full source release, have a look at SH Core Linux 20110317:
http://www.spinics.net/lists/linux-sh/msg07188.html

The SH kernel patch shows how to make use of the virtio platform driver.

Cheers,

/ magnus
