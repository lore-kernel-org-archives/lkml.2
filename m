Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab1LCRV1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 12:21:27 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35165 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab1LCRVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 12:21:24 -0500
MIME-Version: 1.0
In-Reply-To: <4EDA4AB4.90303@linuxtv.org>
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com>
	<4ED6C5B8.8040803@linuxtv.org>
	<4ED75F53.30709@redhat.com>
	<CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com>
	<20111202231909.1ca311e2@lxorguk.ukuu.org.uk>
	<4EDA4AB4.90303@linuxtv.org>
Date: Sat, 3 Dec 2011 09:21:23 -0800
Message-ID: <CAA7C2qjfWW8=kePZDO4nYR913RyuP-t+u8P9LV4mDh9bANr3=Q@mail.gmail.com>
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver
 because of worrying about possible misusage?
From: VDR User <user.vdr@gmail.com>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, HoP <jpetrous@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 3, 2011 at 8:13 AM, Andreas Oberritter <obi@linuxtv.org> wrote:
> You could certainly build a library to reach a different goal. The goal
> of vtuner is to access remote tuners with any existing program
> implementing the DVB API.

So you could finally use VDR as a server/client setup using vtuner,
right? With full OSD, timer, etc? Yes, I'm aware that streamdev
exists. It was horrible when I tried it last (a long time ago) and I
understand it's gotten better. But it's not a suitable replacement for
a real server/client setup. It sounds like using vtuner, this would
finally be possible and since Klaus has no intention of ever
modernizing VDR into server/client (that I'm aware of), it's also the
only suitable option as well.

Or am I wrong about anything?  If not, I know several users who would
like to use this, myself included.
