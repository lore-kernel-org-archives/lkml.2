Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab0K2Msh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 07:48:37 -0500
Received: from mail.sysgo.com ([195.145.229.155]:34610 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab0K2Msg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 07:48:36 -0500
Date: Mon, 29 Nov 2010 13:48:44 +0100
From: Pavel Machek <pma@sysgo.com>
To: Sujith <m.sujith@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
        kernel list <linux-kernel@vger.kernel.org>,
        "chunkeey@googlemail.com" <chunkeey@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "rudolf.marek@sysgo.com" <rudolf.marek@sysgo.com>,
        "cko@sysgo.com" <cko@sysgo.com>, "mfa@sysgo.com" <mfa@sysgo.com>,
        "anl@sysgo.com" <anl@sysgo.com>
Subject: Re: ath9k_htc vs. powerpc (was Re: working usb wifi card, that is
 still possible to buy)
Message-ID: <20101129124844.GA31518@pma.sysgo.com>
References: <20101124081616.GA30595@pma.sysgo.com>
 <20101124131320.GA2611@pma.sysgo.com>
 <4CED33E0.5040000@lwfinger.net>
 <20101126083125.GA28982@pma.sysgo.com>
 <20101126102026.GA11857@pma.sysgo.com>
 <20101126112737.GB11857@pma.sysgo.com>
 <19695.40541.335361.81396@gargle.gargle.HOWL>
 <20101126123706.GA19755@pma.sysgo.com>
 <20101129100159.GC28833@pma.sysgo.com>
 <19699.40557.302196.832862@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19699.40557.302196.832862@gargle.gargle.HOWL>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > ...so I indentified two endianness problems in eeprom, but even with
> > both fixed, it still will not associate. Is there some way to dump USB
> > packets, then compare them between PC and PowerPC versions? Should I
> > expect them to match?
> 
> Does this patch help ?

No, it does not seem to. (I did apply it on top of other fixes, but
they should not interfere.)

								Pavel
