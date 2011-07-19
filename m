Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab1GSFfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 01:35:03 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41882 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab1GSFfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 01:35:01 -0400
MIME-Version: 1.0
In-Reply-To: <201107162350.51025.rjw@sisk.pl>
References: <201107162350.51025.rjw@sisk.pl>
Date: Tue, 19 Jul 2011 14:35:00 +0900
Message-ID: <CACBHAewP5twv0X=SOJw+Yb0HVvr7binRQ+VknSzh6=dVBPw_ww@mail.gmail.com>
Subject: Re: [GIT PULL] MIPS build fix related to power management for 3.0
From: Yuasa Yoichi <tripeaks@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/7/17 Rafael J. Wysocki <rjw@sisk.pl>:
> Hi Linus,
>
> Please pull a MIPS build fix related to PM for 3.0 from:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes
>
> It fixes a build regression resulting from a missing conversion from using
> a sysdev to using syscore_ops for PM/shutdown in the MIPS tree.

It has already been fixed in MIPS tree.

Yoichi
