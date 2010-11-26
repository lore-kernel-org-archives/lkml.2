Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab0KZLrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 06:47:43 -0500
Received: from mail.atheros.com ([12.19.149.2]:32537 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab0KZLrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 06:47:42 -0500
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <19695.40541.335361.81396@gargle.gargle.HOWL>
Date: Fri, 26 Nov 2010 17:17:41 +0530
To: Pavel Machek <pma@sysgo.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
        "ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
        kernel list <linux-kernel@vger.kernel.org>,
        "chunkeey@googlemail.com" <chunkeey@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "rudolf.marek@sysgo.com" <rudolf.marek@sysgo.com>,
        "cko@sysgo.com" <cko@sysgo.com>, "mfa@sysgo.com" <mfa@sysgo.com>,
        "anl@sysgo.com" <anl@sysgo.com>
Subject: Re: ath9k_htc vs. powerpc (was Re: working usb wifi card, that is still possible to buy)
In-Reply-To: <20101126112737.GB11857@pma.sysgo.com>
References: <20101103092431.GA21138@pma.sysgo.com>
	<20101124081616.GA30595@pma.sysgo.com>
	<20101124131320.GA2611@pma.sysgo.com>
	<4CED33E0.5040000@lwfinger.net>
	<20101126083125.GA28982@pma.sysgo.com>
	<20101126102026.GA11857@pma.sysgo.com>
	<20101126112737.GB11857@pma.sysgo.com>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
> Sujith, I see you fought with endianness issues on ath9k_htc
> driver. Was you able to test it on actual hardware? Should I try the
> version just after your commit?

No, I never had a chance to test the driver on a big-endian system.
I assume you are referring to this commit: "ath9k_htc: Fix sparse endian warnings" ?

Does using latest wireless-testing help ?
Or you can try compat-wireless to get the latest code.

> > Editing ath_print() works. Question is what is relevant debug info for this...?

Please see: http://wireless.kernel.org/en/users/Drivers/ath9k/debug
'modprobe ath9k_htc debug=0x4601' should give some useful output.

Sujith
