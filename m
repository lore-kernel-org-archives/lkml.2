Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422728Ab2JYOKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:10:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61861 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935102Ab2JYOKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:10:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: James Hogan <james.hogan@imgtec.com>
Subject: Re: [PATCH] asm-generic/io.h: remove asm/cacheflush.h include
Date: Thu, 25 Oct 2012 14:10:23 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Jonas Bonn <jonas@southpole.se>, linux-arch@vger.kernel.org,
        linux@openrisc.net, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-xtensa@linux-xtensa.org,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        "Mike Frysinger" <vapier@gentoo.org>,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
References: <1350984117-17369-1-git-send-email-james.hogan@imgtec.com> <1351172416.6232.70.camel@jerome.southpole.se> <5089479F.6070608@imgtec.com>
In-Reply-To: <5089479F.6070608@imgtec.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201210251410.23720.arnd@arndb.de>
X-Provags-ID: V02:K0:W43sYoil2XSY7hfPuDnykAHElAIx7F61muyLETdeixI
 wQd/o8SHddRanxI6UAIJxWwJl5hJ7/ofAwbe5RdrgDV35qwqub
 Dq/kf7dd7qjrHQeuc35/BL9/Z/bYXRYKAyEUJZzO04DGQV5GnS
 ezoY9uVNSd26opHudxfRCLVuIs8QJiYIYXG/3nq50o32Wwt3YM
 hpT4kGjjav8dal35JsZtUj/ieeKZr8qKriuQrpHhWAm/CQWWg5
 +GwhKo+AY8laF+luOV/t3neqWxn/6YrerSt1ROYoGusCrnncIW
 F/TcDMWoYBwjHHiyUeLt1wE1+gf0os6GBS9Ubuj/cmMKFMAwPa
 YbeR7YzTkJbsOb/EiO/U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 October 2012, James Hogan wrote:
> > Who's tree should this go via.  I can take it via the openrisc
> > tree, but it would be good to get some Ack's that this isn't going
> > to break things for the other arch's (in particular score and
> > unicore32, since they are untested).
> 
> Yeh I'd like some acks from score and unicore32 if possible, since I
> didn't notice I needed the openrisc bit until I tried compiling it.

I'm not worried about score, because there have been no updates at
all for the entire last year, and I doubt anyone is using that any
more. I agree that having an Ack from Guan Xuetao would be good.

The patch will also show up in linux-next now, and I can update
it if necessary.

	Arnd
