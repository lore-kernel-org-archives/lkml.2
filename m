Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab1FXVud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 17:50:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:46748 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab1FXVu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 17:50:29 -0400
Message-ID: <4E050684.8010003@infradead.org>
Date: Fri, 24 Jun 2011 18:49:56 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Andy Walls <awalls@md.metrocast.net>,
        Hans Verkuil <hverkuil@xs4all.nl>, Jesper Juhl <jj@chaosbits.net>,
        LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        linux-media@vger.kernel.org, ceph-devel@vger.kernel.org,
        Sage Weil <sage@newdream.net>
Subject: Re: [RFC] Don't use linux/version.h anymore to indicate a per-driver
 version - Was: Re: [PATCH 03/37] Remove unneeded version.h includes from
 include/
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>	<4E04912A.4090305@infradead.org>	<BANLkTim9cBiiK_GsZaspxpPJQDBvAcKCWg@mail.gmail.com>	<201106241554.10751.hverkuil@xs4all.nl>	<4E04A122.2080002@infradead.org>	<20110624203404.7a3f6f6a@stein>	<BANLkTimj-oEDvWxMao6zJ_sudUntEVjO1w@mail.gmail.com>	<1308949448.2093.20.camel@morgan.silverblock.net>	<20110624232048.66f1f98c@stein> <BANLkTinZoax2fcSxvyQgfsT-bmsF+BofyQ@mail.gmail.com>
In-Reply-To: <BANLkTinZoax2fcSxvyQgfsT-bmsF+BofyQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 24-06-2011 18:22, Devin Heitmueller escreveu:
> On Fri, Jun 24, 2011 at 5:20 PM, Stefan Richter
> <stefanr@s5r6.in-berlin.de> wrote:
>> Easier:
>>  "I run Ubuntu 10.4".
>>  "I run kernel 2.6.32."
>> One of these is usually already included in the first post or IRC message
>> from the user.
>>
>> Separate driver versions are only needed on platforms where drivers are
>> not distributed by the operating system distributor, or driver source code
>> is not released within kernel source code.
> 
> Unfortunately, this doesn't work as all too often the user has "Ubuntu
> 10.1 but I installed the latest media_build tree a few months ago".

> Hence they are not necessarily on a particular binary release from a
> distro but rather have a mix of a distro's binary release and a
> v4l-dvb tree compiled from source.


# modprobe vivi
# dmesg
WARNING: You are using an experimental version of the media stack.
	As the driver is backported to an older kernel, it doesn't offer
	enough quality for its usage in production.
	Use it with care.
Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
	d3302689d697a99d565ea37c8fb9a19a1a5d0f06 [media] rc-core: fix winbond-cir issues
	6337ae50f81c99efbf9fa924c9d1b8b51efbcef2 [media] rc/redrat3: dereferencing null pointer
	ad0fc4c9ac8bf871b7bf874b2cd34b6b65f099c7 [media] rc: double unlock in rc_register_device()
vivi-000: V4L2 device registered as video0
Video Technology Magazine Virtual Video Capture Board ver 0.8.0 successfully loaded.

The git changeset is a way better than a version number.

Mauro.
