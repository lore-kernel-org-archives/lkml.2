Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab0CaVON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 17:14:13 -0400
Received: from mail-iw0-f202.google.com ([209.85.223.202]:35547 "EHLO
	mail-iw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab0CaVOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 17:14:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=H7f11CbEvlenW+Gk8NtWBKDjyF8FKeHWkBtiU6AhA2WHUmO5Avb2mBVgLO7hJ/MNWZ
         7trY5VESYjsYf4S78lgXa9THDXKWDCEm1EuU3ehOqd1b9I/QCFQZeK6WJmFV+ejcvrmY
         Io6BCpuE41naD1FQhG/cLAwEgSRXFI5rYDPa0=
MIME-Version: 1.0
In-Reply-To: <20100331185916.GA12306@elte.hu>
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org>
	 <4BB2EB1B.8090303@zytor.com>
	 <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org>
	 <20100331185916.GA12306@elte.hu>
Date: Thu, 1 Apr 2010 07:14:08 +1000
Message-ID: <r2h21d7e9971003311414pc38f5bebk1778a01872657395@mail.gmail.com>
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
From: Dave Airlie <airlied@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: James Morris <jmorris@namei.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
       airlied@linux.ie, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 1, 2010 at 4:59 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * James Morris <jmorris@namei.org> wrote:
>
>> On Tue, 30 Mar 2010, H. Peter Anvin wrote:
>>
>> > On 03/30/2010 09:49 PM, James Morris wrote:
>> > >
>> > > Please make NO_BOOTMEM default to n, at least for amd64, where I've found
>> > > that it leads to all kinds of strange, undebuggable boot hangs and errors
>> > > (with relatively current Fedora development userland).
>> >
>> > Have you tested it with the latest fixes that are now in Linus' tree (-rc3)?
>>
>> Yes, it was happening with -rc3.
>
> Could you please send the bootlog that Yinghai asked for, plus also one that
> you get with NO_BOOTMEM turned off (for comparison)?
>
> Also, when did you first hit this bug? This code has been upstream for almost
> a month, and it was in linux-next before that - so you should have hit this
> much sooner. A rough timeframe would suffice. I suppose you were booting
> upstream kernels during the merge window as well?
>
> We can flip the default around if there's no fix available based on the
> bootlogs. (Plus the help text should definitely be improved.)
>

Are you testing this btw with initramfs/initrds? I suspect lots of testing
is being done by people on monolithic kernels, this is just a misc guess,
considering I couldn't boot from when this landed until rc3 with this option
on a basic 32-bit install on a dual-core 64-bit CPU, it suggested a
hole of some sort
in the test coverage.

Dave
