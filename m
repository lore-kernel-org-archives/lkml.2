Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab0KAWHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 18:07:20 -0400
Received: from foo.birdnet.se ([213.88.146.6]:51868 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751093Ab0KAWHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 18:07:16 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Nov 2010 18:07:15 EDT
Message-ID: <20101101220033.416.qmail@stuge.se>
Date: Mon, 1 Nov 2010 23:00:33 +0100
From: Peter Stuge <peter@stuge.se>
To: guillermo arias <papaguillee18@gmail.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, linux-pcmcia@lists.infradead.org
Subject: Re: PATCH : linux-2.6.35.4 drivers pcmcia cs.c
Mail-Followup-To: guillermo arias <papaguillee18@gmail.com>,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	linux-pcmcia@lists.infradead.org
References: <AANLkTikbEgfVZmnVfbgGxbybbghXCuUgvEm03HH=i4HD@mail.gmail.com> <20101101160529.GA9306@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101101160529.GA9306@comet.dominikbrodowski.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dominik Brodowski wrote:
> indeed, on a IBM ThinkPad 770Z there seems to be some bug -- the CardBus
> hardware doesn't tell the OS that it is CardBus capable.

What hardware is this, and how would it tell the OS?

Is it certain that the hardware *is* actually cardbus capable?


> 2) What's the output of "lspci -n -v"
> 3) What's the output of "sudo lspcmcia -vvv"

Yes please.


> 4) Are there any BIOS options you may toggle to enable CardBus?


//Peter
