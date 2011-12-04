Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab1LDAOJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 19:14:09 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48684 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab1LDAOH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 19:14:07 -0500
MIME-Version: 1.0
In-Reply-To: <aff8302dd6c3eb047c39d3a2d1fd2382@mail.eetvelt.be>
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com>
	<4ED6C5B8.8040803@linuxtv.org>
	<4ED75F53.30709@redhat.com>
	<CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com>
	<20111202231909.1ca311e2@lxorguk.ukuu.org.uk>
	<4EDA4AB4.90303@linuxtv.org>
	<CAA7C2qjfWW8=kePZDO4nYR913RyuP-t+u8P9LV4mDh9bANr3=Q@mail.gmail.com>
	<aff8302dd6c3eb047c39d3a2d1fd2382@mail.eetvelt.be>
Date: Sat, 3 Dec 2011 16:14:06 -0800
Message-ID: <CAA7C2qgz1GYhVwXwiO5dt09+Mv0719tfCBmK7ud07RZ2VDNxTw@mail.gmail.com>
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver
 because of worrying about possible misusage?
From: VDR User <user.vdr@gmail.com>
To: Walter Van Eetvelt <walter@van.eetvelt.be>
Cc: Andreas Oberritter <obi@linuxtv.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        HoP <jpetrous@gmail.com>, Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 3, 2011 at 3:30 PM, Walter Van Eetvelt
<walter@van.eetvelt.be> wrote:
>> So you could finally use VDR as a server/client setup using vtuner,
>> right? With full OSD, timer, etc? Yes, I'm aware that streamdev
>> exists. It was horrible when I tried it last (a long time ago) and I
>> understand it's gotten better. But it's not a suitable replacement for
>> a real server/client setup. It sounds like using vtuner, this would
>> finally be possible and since Klaus has no intention of ever
>> modernizing VDR into server/client (that I'm aware of), it's also the
>> only suitable option as well.
>>
>> Or am I wrong about anything?  If not, I know several users who would
>> like to use this, myself included.
>
> This is the question on how you provide (live)tv content to multiple users
> and devices.
> And I think this goes beyond the simple "second PC in the house" where you
> want to watch TV or recordings.  How can you watch streams from your DVB
> device on your small screen Mobile phone/tablet?  Or stream over the
> internet and watch your last night recording when commuting in the train?
> Some commercial solutions are already available for some scenario's.  Also
> free software solutions support for some scenario's, but I think still too
> limited.
>
> With that in mind, for me the future is for a client server combination
> that can do proper live TV and recording streaming.
> And technically, a virtual driver is not bringing better user experience
> in the long term I think.  On the contrary, some users would use the
> vtunerc to fill in some of their needs.  This could bring developers to
> work less on client/server application supporting a broader range of use
> cases.

While I agree with your more broad view of the issue, I specifically
talked about VDR.  AFAIK Klaus has no intention of adding true
server/client support to VDR, so for VDR users, this sounds like it
could be a working solution without the strict limitations of
streamdev.
