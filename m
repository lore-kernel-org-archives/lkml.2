Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087Ab1EaSX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:23:59 -0400
Received: from mail.lang.hm ([64.81.33.126]:58364 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758000Ab1EaSX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:23:58 -0400
Date: Tue, 31 May 2011 11:23:24 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "D. Jansen" <d.g.jansen@googlemail.com>
cc: "Ted Ts'o" <tytso@mit.edu>, Oliver Neukum <oneukum@suse.de>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, njs@pobox.com, bart@samwel.tk
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
In-Reply-To: <BANLkTim0pFS=Fs6ga2CV5LwOs2xxbh9svA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1105311122250.30137@asgard.lang.hm>
References: <AC254312-8FFF-4070-BF8B-D9B1E8FF1AE6@mit.edu> <BANLkTi=BgGagV+dN9-nFcSkNsGNKbRMLfQ@mail.gmail.com> <alpine.DEB.2.02.1105291850260.5766@asgard.lang.hm> <BANLkTik69Gb2i1467bhnEU-pJ0WB10mqNQ@mail.gmail.com> <alpine.DEB.2.02.1105301058030.5766@asgard.lang.hm>
 <BANLkTimtY0ggu28i-9VzWOO1=puZ0JvcAQ@mail.gmail.com> <alpine.DEB.2.02.1105301142030.5766@asgard.lang.hm> <BANLkTimuToT90eRGVRfN9tAHoF9GOSRRDA@mail.gmail.com> <alpine.DEB.2.02.1105301349530.5766@asgard.lang.hm> <BANLkTimSLoY3uwtGvA2x5C0HhNEHvmWqzw@mail.gmail.com>
 <20110531020300.GJ2890@dhcp-172-31-194-241.cam.corp.google.com> <BANLkTim0pFS=Fs6ga2CV5LwOs2xxbh9svA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="680960-314092539-1306866205=:30137"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--680960-314092539-1306866205=:30137
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 31 May 2011, D. Jansen wrote:

> On Tue, May 31, 2011 at 4:03 AM, Ted Ts'o <tytso@mit.edu> wrote:
>> On Mon, May 30, 2011 at 11:24:03PM +0200, D. Jansen wrote:
>>>> do you really have so many fsync's going on that the disk spins up so much
>>>> that you would gain 10-20% battery life?
>>>
>>> Yes. Every autosave in LibreOffice triggers one. And I want autosave,
>>> but I want them in memory, not on disk.
>>
>> What on *heck* good does an autosave to memory do?  Are you afraid
>> your X server is going to go poof, or OpenOffice is going to crash on
>> you?
> Unfortunately, yes. This happens to me regularly, e.g. roughly every
> 10th resume. It's a poulsbo system. ;)
> Another reason is a Java extension that makes it crash happy.
> (Please don't tell me now that the real fix is to fix poulsbo...)
>
>> I can't remember the last time this has happened to me.  It's
>> typically a system crash or a power loss that causes me to lose an
>> OpenOffice session.
>
> Well, good for you! Power loss didn't ever occur to me on the other
> hand, at least not on my netbook.

failure to resume is effectivly power loss. a autosave to ram would be 
lost, just like with a power loss or system crash.

David Lang
--680960-314092539-1306866205=:30137--
