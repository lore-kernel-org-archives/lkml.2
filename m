Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab1LEGUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 01:20:44 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37029 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab1LEGUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 01:20:43 -0500
MIME-Version: 1.0
In-Reply-To: <CAA7C2qgDOgqZqkXE+E=H1yTrA0Uc4r-31y40BVa2=BxOaJY6Kw@mail.gmail.com>
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com>
	<4ED6C5B8.8040803@linuxtv.org>
	<4ED75F53.30709@redhat.com>
	<CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com>
	<20111202231909.1ca311e2@lxorguk.ukuu.org.uk>
	<4EDA4AB4.90303@linuxtv.org>
	<CAA7C2qjfWW8=kePZDO4nYR913RyuP-t+u8P9LV4mDh9bANr3=Q@mail.gmail.com>
	<CAJbz7-15mzUNV7ZLSkAOg1Vb8briysitsR7xK94G+3-KT=ZXbA@mail.gmail.com>
	<CAA7C2qgDOgqZqkXE+E=H1yTrA0Uc4r-31y40BVa2=BxOaJY6Kw@mail.gmail.com>
Date: Mon, 5 Dec 2011 07:20:42 +0100
Message-ID: <CAJbz7-1JLc0yq=9NUTNiP5zcG7vyC9ao_seU8rudCwXi3YoGdQ@mail.gmail.com>
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver
 because of worrying about possible misusage?
From: HoP <jpetrous@gmail.com>
To: VDR User <user.vdr@gmail.com>
Cc: Andreas Oberritter <obi@linuxtv.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Well, initial report was made on vdr-portal because of our hardware announce,
>> but you can be sure the same is true if server is build on any linux hardware.
>> Here is some note:
>> http://www.vdr-portal.de/board18-vdr-hardware/board84-allgemein/106610-das-neue-netzwerk-client-der-f%C3%BCr-vdr-verwenden-k%C3%B6nnen/?highlight=vtuner
>>
>> Additional info you can find (or ask) on our forum:
>> http://forum.nessiedvb.org/forum/viewforum.php?f=11
>>
>> Please note, that compilation of vtunerc kernel driver (or loopback, or pigback
>> or whatever name the code should be used) is simple - no need for any
>> kernel real patching is required. Code can be compiled outside of the
>> kernel tree
>> (of course kernel headers are still needed).
>>
>> Some useful hints regarding userland application daemons you
>> can find in our wiki:
>> http://wiki.nessiedvb.org/wiki/doku.php?id=vtuner_mode
>>
>> When you get vtunerc and vtunerd applications connected, try
>> simple command line tuning (szap/tzap or czap) to check
>> if it works correctly. Only if you get zapping working switch
>> to vdr.
>
> Thanks for the info and links. I do know many guys who would be
> interested in this if it can provide good server/client ability with
> VDR. However, a large number of us only speak english so places like
> vdr-portal aren't much use a lot of the time. If you have english
> forums somewhere, that link would be far more useful I think.

No problem. Simply ignore first URL. All others are english :-)

I would recommend start from how-it-works-diagram:
http://code.google.com/p/vtuner/wiki/BigPicture

and then have a look  at wiki. where you can some
step-by-step info.

Anyway, don't hesitate to ask any question in our forum
or write me directly.

Honza
