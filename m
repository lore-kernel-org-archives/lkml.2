Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab2AHXOD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 18:14:03 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:35139 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754602Ab2AHXOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 18:14:02 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1201082319560.24030@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201082028140.24030@swampdragon.chaosbits.net>
	<CA+55aFwO9Wtq=NEpMskW-2wrWZAGh-C6VBXENA3LtFOk=tUwgQ@mail.gmail.com>
	<1326058974.5372.4.camel@joe2Laptop>
	<alpine.LNX.2.00.1201082319560.24030@swampdragon.chaosbits.net>
Date: Sun, 8 Jan 2012 15:14:01 -0800
Message-ID: <CAHLZz13J2KxsumzG9hvAgWXObX=TwNL3Kf218bNtFWSuA0ggyg@mail.gmail.com>
Subject: Re: Please merge two small bug fix patches from linux-next
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 8, 2012 at 2:21 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> On Sun, 8 Jan 2012, Joe Perches wrote:
>
>> On Sun, 2012-01-08 at 13:26 -0800, Linus Torvalds wrote:
>> > On Sun, Jan 8, 2012 at 11:51 AM, Jesper Juhl <jj@chaosbits.net> wrote:
>> > > Below are two patches that have been in linux-next for ages (via akpm's
>> > > tree). They are prette simple, straight-up, bug fixes. They have been
>> > > submitted to maintainers multiple times over (IIRC at least the past
>> > > year), but for some reason the maintainers seem uninterested in picking
>> > > them up (or even responding to them).
>> []
>> > they seem to have Andrew's sign-off, so I'd have expected them to
>> > come through Andew. What's up?
>>
>> >From my perspective, the issue lies with James'
>> apparent desire to keep scsi tree changes as close
>> to zero as possible.
>>
>> Many obvious corrections to scsi defects have gone
>> unapplied.
>>
>
> I have to agree. It's actually gotten to the point that I personally
> completely avoid/ignore scsi code when looking for stuff to fix/improve
> since I don't expect to be able to get the patches merged anyway..
>

Basically the same experience here trying to submit sparse annotations
or patched using the get_unaligned_*
functions instead of explicit byte-shifting.

Harvey
