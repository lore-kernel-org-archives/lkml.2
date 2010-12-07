Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab0LGNWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 08:22:33 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50485 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab0LGNWc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 08:22:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Mdg2u2cKiAAxKxU44AP3JV4mDJ9UdtS0109y9T6fDDMW+mRY4gfD1nG+gNGlK/s4n6
         vZmRcvHdldGhl70qscKGHiKz3eV8By2lypWsVXwsaPaep6ZvJg0HIum2DXNCBN6ZniFd
         lBOcvp+4H/K/kdx5XpVUJMozqQ5vKW8skzweo=
MIME-Version: 1.0
In-Reply-To: <20101206145447.GB3117@redhat.com>
References: <AANLkTi=aqMR0uNCgz40pdUG1288CMxLRnZdVxzZuBzGw@mail.gmail.com>
	<20101130145712.GD26758@redhat.com>
	<AANLkTik_x-SSU1aazJ3ZqJdsbq11vh3+=ikwbpxNcRYh@mail.gmail.com>
	<20101201144128.GC4672@redhat.com>
	<AANLkTinGChRaNUeH+AzS+6Y3Au+0BR1Mz97W8aDSoyQf@mail.gmail.com>
	<20101203143256.GA30407@redhat.com>
	<AANLkTikJj+ByPuLK7NEqQd37E=njAiTnOeiLQJcSJBXg@mail.gmail.com>
	<20101206145447.GB3117@redhat.com>
Date: Tue, 7 Dec 2010 21:22:31 +0800
Message-ID: <AANLkTinxwZyduUpowiqTHnOMB6Do=V3=oQFOBkbisTTC@mail.gmail.com>
Subject: Re: [PATCH] maximize dispatching in block throttle
From: Hillf Danton <dhillf@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 6, 2010 at 10:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Sat, Dec 04, 2010 at 09:36:40PM +0800, Hillf Danton wrote:
>> On Fri, Dec 3, 2010 at 10:32 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > It should not be too hard. IO schedulers already create
>> > /sys/block/<dev>/queue/iosched/ dir and we can create <dev>/queue/throttle/
>> > dir and export throttle related tunables there.
>>
>> Evening, Vivek.
>>
>> I worked the framework for the tunable out.
>>
>> If in right direction, I will complete it soon.
>
> Hillf,
>
> You still have not answered my questions in previous mail.

Thank you, Vivek, for patience first.

>
> - What's the problem are you facing and how filling the quantum to the
>  capacity is helping you.

The community in which we live holds multiple elements, you see, and
it is not rare that readers could have different sights from the
writer of the artwork concerned. As the quantum defined, dispatching
should be as natural and smoothly as definition permits. And it
happened that the same concern is raised by other readers.

There are only two chances left in block throttle, a new concept in
block dir, for its readers. I was moved by the art of rb_tree at first
peek, and even tried to find the mm leakage of throttle group but
failed :-0)

>
> - Tunable and filling the quantum are two different things. If filling
>  the quantum solved your problem, then how tunable is going to solve
>  same problem.

Tunable looks necessary here since the maintainer of block offers
sysfs methods to tune his elevators, even in case of the CFQ. That is
the cool way to solve problems, I think.

>
> I don't want to introduce tunables if they are really not put to use
> by somebody. So before we move in this direction, lets first answer
> above questions.

The naive framework for the tunable is prepared for playing my games,
and shared if others concern, not ready for block throttle yet
currently, but it should be in right direction first. And it is honor
to ask for confirm from the author, right?

Cheers
Hillf
