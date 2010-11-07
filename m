Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab0KGXJe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 18:09:34 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44608 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab0KGXJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 18:09:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Fm2ztz+eiRSl/56zjZJqnxmu/rt6VW1ybMMWeGB5BsqjZt2v+mMRke/6tOgU7An2ak
         dE8r2/ubpmO4a0N8uH9JP4kYF7JNXHHBW2t9h/PtBaT1qN0QUq+MN3T/p1ZL72LST1ii
         ztuQ9Y68AUbwX2fCYbXO55cs8ofdXT3wHrdzg=
MIME-Version: 1.0
In-Reply-To: <20101107215908.GA21070@kroah.com>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com>
	<AANLkTi=UxhRdcDaoKaYVWhPkp_e-uLF4=zhXs7gutkgx@mail.gmail.com>
	<20101106181202.GA6927@kroah.com>
	<39580686-A899-4689-BAAD-AF5546B34E49@mac.com>
	<AANLkTimVsUsrmTvsHqFiqJh1hhryMBemGyW+kYLKGgEu@mail.gmail.com>
	<20101107155757.GA13736@kroah.com>
	<AANLkTik=UWwRLOaHMfVifYiQPpSwoYuA6J1EoL5BOgJY@mail.gmail.com>
	<20101107215908.GA21070@kroah.com>
Date: Sun, 7 Nov 2010 18:09:33 -0500
Message-ID: <AANLkTimMpGiEHgx03k22wiH-1uzAL-KJm3GADe4bBF_J@mail.gmail.com>
Subject: Re: Forked android kernel development from linux kernel mainline
From: Arnaud Lacombe <lacombar@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Anca Emanuel <anca.emanuel@gmail.com>, Elvis Dowson <elvis.dowson@mac.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Nov 7, 2010 at 4:59 PM, Greg KH <greg@kroah.com> wrote:
> On Sun, Nov 07, 2010 at 04:44:48PM -0500, Arnaud Lacombe wrote:
>> Hi,
>>
>> On Sun, Nov 7, 2010 at 10:57 AM, Greg KH <greg@kroah.com> wrote:
>> > [...]
>> >
>> Just a small comment to say that Android is not the only one (but
>> certainly the most visible, and thus easiest to bash on) not making
>> effort to get their stuff in mainline. OpenWRT people are also
>> maintaining their fork of the kernel, without even using git, and not
>> contributing much to mainline (I'm certainly mistaken on that last
>> comment).
>
> Isn't the openwrt stuff just drivers and some arch specific code?
> Nothing that is core infrastructure, and nothing preventing them from
> submitting the drivers and arch code if they want to, right?
>
>From what I can see, yes.

> If so, why don't you submit it?
>
because I have no knowledge on the code, nor have any documentation on
the underlying hardware. That said, it's in my TODO, but stuff keeps
getting in before this entry.

>Why don't they?
>
I just checked with some dev on IRC, there might be a time issue. The
patches have been synced with 2.6.36 recently (a month ago). So
there're still hope :)

 - Arnaud
