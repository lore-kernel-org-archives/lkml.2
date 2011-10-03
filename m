Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab1JCJvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:51:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62002 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab1JCJvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:51:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/30] video/omap: fix dependencies
Date: Mon, 03 Oct 2011 11:51:10 +0200
Message-ID: <4098767.aLCa4gBHda@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <1317624830.2026.6.camel@deskari>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <1317566760-25681-3-git-send-email-arnd@arndb.de> <1317624830.2026.6.camel@deskari>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:wrg3hSnh68J3I4YktZSJL4uOBiPYCYRy0YTefDnYLQt
 ZLAl/VVlaVsE5G+5JJeN2jLXRKl90t0Q+obvgMNZMYb955yzSk
 oN+mNI0pStMV7gmqmxtXklj4aRIXclYcnCd4fc1GrPMEOHomli
 8cmLiOF0wMnheD8GksmfxwqhqDXcblQsc/F35ZMnPQSfHc3UWz
 hxZvbJiduYESTTuptmkWNbwfPQJWE1ogeQZuj9AcVZ9pU6ukIs
 apMEaV6jCuDrNP8klyeuidEf+o4DSV2qqDP/55TEPOM8c6ihQU
 OX/LHItzOX9hY/UC24aFnmEvdbZa1uo5ktcxgmoK/Ao761dr12
 VSdRYi8bEl4rk753ExRU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 October 2011 09:53:50 Tomi Valkeinen wrote:
> Your patch will conflict with both of those changes. Is it ok for you to
> drop this patch, and I'll make a new one on top of my changes to clean
> up the Makefile in a similar way than you did? The new patch wouldn't
> make it in the next merge window, though, but I don't think this patch
> is fixing any bigger bug, so perhaps it's not so urgent.

Sure, no problem. I'll put it into my "hacks" branch then, so I can
still do randconfig builds and we get back to it later.

	Arnd
