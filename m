Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab1LDXWZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 18:22:25 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37057 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab1LDXWX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 18:22:23 -0500
MIME-Version: 1.0
In-Reply-To: <CAA7C2qjfWW8=kePZDO4nYR913RyuP-t+u8P9LV4mDh9bANr3=Q@mail.gmail.com>
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com>
	<4ED6C5B8.8040803@linuxtv.org>
	<4ED75F53.30709@redhat.com>
	<CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com>
	<20111202231909.1ca311e2@lxorguk.ukuu.org.uk>
	<4EDA4AB4.90303@linuxtv.org>
	<CAA7C2qjfWW8=kePZDO4nYR913RyuP-t+u8P9LV4mDh9bANr3=Q@mail.gmail.com>
Date: Mon, 5 Dec 2011 00:22:22 +0100
Message-ID: <CAJbz7-15mzUNV7ZLSkAOg1Vb8briysitsR7xK94G+3-KT=ZXbA@mail.gmail.com>
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver
 because of worrying about possible misusage?
From: HoP <jpetrous@gmail.com>
To: VDR User <user.vdr@gmail.com>
Cc: Andreas Oberritter <obi@linuxtv.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

2011/12/3 VDR User <user.vdr@gmail.com>:
> On Sat, Dec 3, 2011 at 8:13 AM, Andreas Oberritter <obi@linuxtv.org> wrote:
>> You could certainly build a library to reach a different goal. The goal
>> of vtuner is to access remote tuners with any existing program
>> implementing the DVB API.
>
> So you could finally use VDR as a server/client setup using vtuner,
> right? With full OSD, timer, etc? Yes, I'm aware that streamdev
> exists. It was horrible when I tried it last (a long time ago) and I
> understand it's gotten better. But it's not a suitable replacement for
> a real server/client setup. It sounds like using vtuner, this would
> finally be possible and since Klaus has no intention of ever
> modernizing VDR into server/client (that I'm aware of), it's also the
> only suitable option as well.
>
> Or am I wrong about anything?  If not, I know several users who would
> like to use this, myself included.

Well, initial report was made on vdr-portal because of our hardware announce,
but you can be sure the same is true if server is build on any linux hardware.
Here is some note:
http://www.vdr-portal.de/board18-vdr-hardware/board84-allgemein/106610-das-neue-netzwerk-client-der-f%C3%BCr-vdr-verwenden-k%C3%B6nnen/?highlight=vtuner

Additional info you can find (or ask) on our forum:
http://forum.nessiedvb.org/forum/viewforum.php?f=11

Please note, that compilation of vtunerc kernel driver (or loopback, or pigback
or whatever name the code should be used) is simple - no need for any
kernel real patching is required. Code can be compiled outside of the
kernel tree
(of course kernel headers are still needed).

Some useful hints regarding userland application daemons you
can find in our wiki:
http://wiki.nessiedvb.org/wiki/doku.php?id=vtuner_mode

When you get vtunerc and vtunerd applications connected, try
simple command line tuning (szap/tzap or czap) to check
if it works correctly. Only if you get zapping working switch
to vdr.

Honza
