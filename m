Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201Ab0KAQMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 12:12:51 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:38213 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753479Ab0KAQMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 12:12:48 -0400
Date: Mon, 1 Nov 2010 17:05:29 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: guillermo arias <papaguillee18@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        linux-pcmcia@lists.infradead.org
Subject: Re: PATCH : linux-2.6.35.4 drivers pcmcia cs.c
Message-ID: <20101101160529.GA9306@comet.dominikbrodowski.net>
Mail-Followup-To: guillermo arias <papaguillee18@gmail.com>,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	linux-pcmcia@lists.infradead.org
References: <AANLkTikbEgfVZmnVfbgGxbybbghXCuUgvEm03HH=i4HD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikbEgfVZmnVfbgGxbybbghXCuUgvEm03HH=i4HD@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

indeed, on a IBM ThinkPad 770Z there seems to be some bug -- the CardBus
hardware doesn't tell the OS that it is CardBus capable. However, your
patch isn't correct -- it would enable CardBus on all PCMCIA bridges
unconditionally. Therefore, I'd need some more input for a proper patch:

1) Did CardBus cards work on any other kernel?

2) What's the output of "lspci -n -v"

3) What's the output of "sudo lspcmcia -vvv"

4) Are there any BIOS options you may toggle to enable CardBus?

Thanks & best wishes,

	Dominik
