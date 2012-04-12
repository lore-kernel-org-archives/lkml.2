Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934284Ab2DLNf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 09:35:56 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57306 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934229Ab2DLNfy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 09:35:54 -0400
MIME-Version: 1.0
In-Reply-To: <20120412121124.64aee2f6@pyramind.ukuu.org.uk>
References: <20120401125741.GA7484@p183.telecom.by>
	<4F78D0BA.9040709@zytor.com>
	<CACVxJT_WJYjecpZMGkyUrbE5gNROX1tOfFAcD84-hoPsypxcFQ@mail.gmail.com>
	<4F7F1659.5090305@zytor.com>
	<20120406201601.GA3310@p183.telecom.by>
	<4F7F59E1.2040009@zytor.com>
	<CACVxJT_RRfW7HknkbA4+41L9hNMBHZNezKs1ifbv_qFx5eB0-w@mail.gmail.com>
	<20120412121124.64aee2f6@pyramind.ukuu.org.uk>
Date: Thu, 12 Apr 2012 16:35:53 +0300
Message-ID: <CACVxJT-Yff7nw2Qd3WX8AbQ2259OgN_fgQ7TvgNMv8A=ysg2JA@mail.gmail.com>
Subject: Re: [PATCH] nextfd(2)
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        drepper@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 2:11 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Thu, 12 Apr 2012 13:54:25 +0300
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
>
>> On Sat, Apr 7, 2012 at 12:02 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> > On 04/06/2012 01:16 PM, Alexey Dobriyan wrote:
>> >>
>> >> closefrom(3) written via nextfd(2) loop is reliable and doesn't fail.
>> >> closefrom(3) written via /proc/self/fd is reliable and can fail (including ENOMEM).
>> >> closefrom(3) written via close(fd++) is unreliable.
>> >>
>> >
>> > I call shenanigans on this.  There is no reason to ENOMEM on the second
>> > written using the fdwalk() implementation I already posted, for example.
>>
>> open("/proc/self/fd") can fail with ENOMEM.
>
> Any syscall can fail with a process kill due to a stack extend on out of
> memory in most configurations. That includes your nextfd stuff
>
> This whole thing is getting stupid. "Perfection is the enemy of
> success".
>
> Your code will also fail when the cat pees on the computer, when the
> power fails and when disk dies. I suspect that other than the cat these
> are all more likely real world cases than your ENOMEM.

You can't see I'm talking about difference only, can you?
Have you read what hpa wrote exactly and what exactly I was answering to?
