Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab1FXVWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 17:22:55 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39321 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab1FXVWx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 17:22:53 -0400
MIME-Version: 1.0
In-Reply-To: <20110624232048.66f1f98c@stein>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
	<4E04912A.4090305@infradead.org>
	<BANLkTim9cBiiK_GsZaspxpPJQDBvAcKCWg@mail.gmail.com>
	<201106241554.10751.hverkuil@xs4all.nl>
	<4E04A122.2080002@infradead.org>
	<20110624203404.7a3f6f6a@stein>
	<BANLkTimj-oEDvWxMao6zJ_sudUntEVjO1w@mail.gmail.com>
	<1308949448.2093.20.camel@morgan.silverblock.net>
	<20110624232048.66f1f98c@stein>
Date: Fri, 24 Jun 2011 17:22:50 -0400
Message-ID: <BANLkTinZoax2fcSxvyQgfsT-bmsF+BofyQ@mail.gmail.com>
Subject: Re: [RFC] Don't use linux/version.h anymore to indicate a per-driver
 version - Was: Re: [PATCH 03/37] Remove unneeded version.h includes from include/
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, Jesper Juhl <jj@chaosbits.net>,
        LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        linux-media@vger.kernel.org, ceph-devel@vger.kernel.org,
        Sage Weil <sage@newdream.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 5:20 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> Easier:
>  "I run Ubuntu 10.4".
>  "I run kernel 2.6.32."
> One of these is usually already included in the first post or IRC message
> from the user.
>
> Separate driver versions are only needed on platforms where drivers are
> not distributed by the operating system distributor, or driver source code
> is not released within kernel source code.

Unfortunately, this doesn't work as all too often the user has "Ubuntu
10.1 but I installed the latest media_build tree a few months ago".
Hence they are not necessarily on a particular binary release from a
distro but rather have a mix of a distro's binary release and a
v4l-dvb tree compiled from source.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
