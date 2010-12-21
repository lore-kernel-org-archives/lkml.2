Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933759Ab0LUKKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 05:10:34 -0500
Received: from mx1.sophos.com ([195.166.81.52]:48990 "EHLO mx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933625Ab0LUKKa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 05:10:30 -0500
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Eric Paris <eparis@redhat.com>
Subject: Re: [GIT PULL] notification bug fixes
Date: Tue, 21 Dec 2010 10:10:24 +0000
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5; KDE/4.4.4; x86_64; ; )
CC: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "LinoSanfilippo@gmx.de" <LinoSanfilippo@gmx.de>,
        "alexey.zaytsev@gmail.com" <alexey.zaytsev@gmail.com>,
        "agruen@linbit.com" <agruen@linbit.com>
References: <1292440647.3042.8.camel@localhost.localdomain>
In-Reply-To: <1292440647.3042.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <201012211010.24701.tvrtko.ursulin@sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 15 Dec 2010 19:17:27 Eric Paris wrote:
> The notable fixes in this pull request include a potential deadlock when
> fanotify listeners exit, an unpriv user kernel memory DoS in inotify,
> and an API (although not ABI) change in fanotify's userspace message to
> support expansion in the next release.

Would you consider pushing e3366737eeee6c3c482af3758c6dcb65eccfa62d and
dependencies (ba611b1c12a230785c25a7b3a5ea948fda8cc137,
http://marc.info/?l=linux-kernel&m=129200322526558&w=2)? It would make it
easier for userspace if first published kernel already had
FAN_READONLY_FALLBACK.

Which also reminds me, would a way to explicitly get the protocol version be
useful?

Tvrtko

Sophos Limited, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 991 2418 08.
