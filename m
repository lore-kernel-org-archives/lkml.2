Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab1DDUTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 16:19:01 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:65452 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab1DDUS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 16:18:58 -0400
Date: Mon, 04 Apr 2011 16:18:33 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Pavel Machek <pavel@ucw.cz>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] APM: delete APM in Linux-2.6.40
In-reply-to: <20110404164456.GA13215@elf.ucw.cz>
Message-id: <alpine.LFD.2.02.1104041615040.5324@x980>
References: <alpine.LFD.2.02.1103232321070.3848@x980>
 <20110324154505.934a56a0.sfr@canb.auug.org.au>
 <alpine.LFD.2.02.1103240336590.4529@x980>
 <20110324102116.GA17446@khazad-dum.debian.net>
 <alpine.LFD.2.02.1103241903030.16085@x980>
 <20110325010705.GB4535@khazad-dum.debian.net>
 <20110404164456.GA13215@elf.ucw.cz>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I still have working thinkpad 560X, my brother occassionaly uses it...

There is no doubt that there are still people running Linux
on old APM laptops.

The question, however, is if they're running (or will run)
the latest upstream kernel.  Further, are they available
to test APM patches to the latest upstream kernel.

> I do not think we should remove APM support like this. It does not
> seem to be huge maintainance burden...

Last week we decided not to delete APM yet.
The jury is still out on APM's idle hooks.

cheers,
Len Brown, Intel Open Source Technology Center

