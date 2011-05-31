Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143Ab1EaSib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:38:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49086 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164Ab1EaSia convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:38:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=AwvJHybcE9VUCYGfKA6YJ6j5kqjCgrRnyFC9mHBSWNMtd9ZppibC4x7Uv5Qw4lTwNO
         sL/vp+BRUitnVKZIUkxidsABT9lh96DrIW26WRSEnTqdrDNd8mHYGiCUJVRt/YrXig9J
         LKkgVQ3GekV1dATARLku5n9T/KH6fHs/deH7Q=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1105311122250.30137@asgard.lang.hm>
References: <AC254312-8FFF-4070-BF8B-D9B1E8FF1AE6@mit.edu> <BANLkTi=BgGagV+dN9-nFcSkNsGNKbRMLfQ@mail.gmail.com>
 <alpine.DEB.2.02.1105291850260.5766@asgard.lang.hm> <BANLkTik69Gb2i1467bhnEU-pJ0WB10mqNQ@mail.gmail.com>
 <alpine.DEB.2.02.1105301058030.5766@asgard.lang.hm> <BANLkTimtY0ggu28i-9VzWOO1=puZ0JvcAQ@mail.gmail.com>
 <alpine.DEB.2.02.1105301142030.5766@asgard.lang.hm> <BANLkTimuToT90eRGVRfN9tAHoF9GOSRRDA@mail.gmail.com>
 <alpine.DEB.2.02.1105301349530.5766@asgard.lang.hm> <BANLkTimSLoY3uwtGvA2x5C0HhNEHvmWqzw@mail.gmail.com>
 <20110531020300.GJ2890@dhcp-172-31-194-241.cam.corp.google.com>
 <BANLkTim0pFS=Fs6ga2CV5LwOs2xxbh9svA@mail.gmail.com> <alpine.DEB.2.02.1105311122250.30137@asgard.lang.hm>
From: "D. Jansen" <d.g.jansen@googlemail.com>
Date: Tue, 31 May 2011 20:37:49 +0200
Message-ID: <BANLkTi=PzyjVPCLfxa9=B6A25_vgHD3o8Q@mail.gmail.com>
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
To: david@lang.hm
Cc: "Ted Ts'o" <tytso@mit.edu>, Oliver Neukum <oneukum@suse.de>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, njs@pobox.com, bart@samwel.tk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 8:23 PM,  <david@lang.hm> wrote:
> On Tue, 31 May 2011, D. Jansen wrote:
>
>> On Tue, May 31, 2011 at 4:03 AM, Ted Ts'o <tytso@mit.edu> wrote:

>>> I can't remember the last time this has happened to me.  It's
>>> typically a system crash or a power loss that causes me to lose an
>>> OpenOffice session.
>>
>> Well, good for you! Power loss didn't ever occur to me on the other
>> hand, at least not on my netbook.
>
> failure to resume is effectivly power loss. a autosave to ram would be lost,
> just like with a power loss or system crash.
>
Well in my case only X crashes and the autosave is saved.
