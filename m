Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab1GZJGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 05:06:23 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35294 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab1GZJGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 05:06:18 -0400
MIME-Version: 1.0
In-Reply-To: <20110725224250.7d6edb83@bob.linux.org.uk>
References: <alpine.LNX.2.00.1107242327030.7103@swampdragon.chaosbits.net>
	<4E2CC55B.5010307@gmail.com>
	<4E2CC6CC.5020204@gmail.com>
	<62472696.BtqhiR95vr@wuerfel>
	<20110725224250.7d6edb83@bob.linux.org.uk>
Date: Tue, 26 Jul 2011 11:06:17 +0200
Message-ID: <CAMeQTsY3T5sPCRYzf8-Xca8y_mWjXSUOOptxHZ2YK5YNL0uvuw@mail.gmail.com>
Subject: Re: GMA500: ERROR: "__bad_udelay" undefined!
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Ryan Mallon <rmallon@gmail.com>,
        Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> A 20 ms busy wait is rather nasty. Can't this be replaced with a
>> sleeping wait (msleep)?
>
> Don't know yet - its on the fixme list to dig into - I think the answer
> is some cases but not all.

IMO, it should be replaced with actually waiting for the vblank and not an
arbitrary time. I think this is fine as long as we don't use it when waiting for
a pipe to disable. And I guess we could sleep while waiting for vblank.

Patrik
