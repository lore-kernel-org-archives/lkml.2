Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032632Ab2CPIb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 04:31:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50660 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161270Ab2CPIbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 04:31:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
Date: Fri, 16 Mar 2012 08:31:06 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Russell King <rmk@arm.linux.org.uk>
References: <20120316174941.40421ba160741a0f6aab6611@canb.auug.org.au>
In-Reply-To: <20120316174941.40421ba160741a0f6aab6611@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203160831.07305.arnd@arndb.de>
X-Provags-ID: V02:K0:4NZoLqCICKkiwCe7p2ROkPikfi/w15OPFuBStvUB0ZE
 2o2/Y6eMJLz3t8Y7az6C8IZ9cYbKRIW7ROLA+FfKxwZ5iVSjMG
 Td9MNbMDoGSJ4q0VbjMrefWptWZoRxolLihd3DrwASiqBBuoZt
 IZaSnOyk87QSFo7DPqJV40S+EMdS1FsEnsMNfc26cwgkHtVCrK
 mZb/rX9+BGOb5g56lx2c+3U7aW5WTwI4I29gKFWgnuIiVGVsug
 o6LpN4Uj57HHciVPYXbSd9U8q2v1eha/bspFpQG2OqYxMLLmWm
 I0Ulwotyjsc4cUy3CDw86vRJxCASafC00V8NjkdPRW++pZiRqW
 sI4Dl5VYfDotT9eO0Sgs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 March 2012, Stephen Rothwell wrote:
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-msm/timer.c between commit f8e56c42e4e3 ("msm: timer:
> Support sched_clock()") from the arm tree and commit 5ca709c16d0f ("ARM:
> local timers: convert MSM to runtime registration interface") from the
> arm-soc tree.

We've had a few conflicts with localtimer patches already and the
solution might be very different and nonobvious. Stephen B, please
check if linux-next still works for you with localtimer enabled.

The fix does look correct to me though.

> I fixed it up (see below) and can carry the fax as necessary.

The fax? I think email will do fine ;-)

Thanks Stephen R,

	Arnd
