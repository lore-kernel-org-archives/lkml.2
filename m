Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab1LEAFU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 19:05:20 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51972 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab1LEAFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 19:05:19 -0500
MIME-Version: 1.0
In-Reply-To: <201112031913.32503.hselasky@c2i.net>
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com>
	<CAA7C2qjfWW8=kePZDO4nYR913RyuP-t+u8P9LV4mDh9bANr3=Q@mail.gmail.com>
	<20111203174247.0bbab100@lxorguk.ukuu.org.uk>
	<201112031913.32503.hselasky@c2i.net>
Date: Mon, 5 Dec 2011 01:05:18 +0100
Message-ID: <CAJbz7-2S-px8Xbz15nb2VDV3dQsaTYbnkxMtNHWDj43EGPLg5w@mail.gmail.com>
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver
 because of worrying about possible misusage?
From: HoP <jpetrous@gmail.com>
To: Hans Petter Selasky <hselasky@c2i.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, VDR User <user.vdr@gmail.com>,
        Andreas Oberritter <obi@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Some input from the sideline reading this discussion. As a FreeBSD'er I would
> very much like to see two things happen:
>
> - vtunerc goes into userspace like a client/server daemon pair using CUSE and
> can support _any_ /dev/dvb/adapter, also those created by CUSE itself. That
> means I could potentially use vtunerc in FreeBSD with drivers like cx88:

Vtuner already has userland client/server pair. The server application
is connecting to _any_ /dev/dvb/adapter device. Please look at small
picture here:
http://code.google.com/p/vtuner/wiki/BigPicture

That means the server part is using totally "clean" linux. Nothing more.

>
> http://corona.homeunix.net/cx88wiki
>
> - DVB-X solution in Linux gets mmap support to avoid endless copying of data
> between kernel and userspace.

Adding nmap support should be straightforward. I have it on my TODO.

Honza
