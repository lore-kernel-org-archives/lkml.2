Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab2DPNbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 09:31:04 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:51266 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab2DPNbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 09:31:01 -0400
Date: Mon, 16 Apr 2012 22:30:57 +0900
From: Norbert Preining <preining@logic.at>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Realtek codec eating up battery?
Message-ID: <20120416133057.GA14223@gamma.logic.tuwien.ac.at>
References: <20120415233813.GA10731@gamma.logic.tuwien.ac.at> <s5h62d0t7ct.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h62d0t7ct.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Iwai-san,

On Mo, 16 Apr 2012, Takashi Iwai wrote:
> There should be no kernel change for such a problem.

Thanks.

> Basically the above message means that no power-saving feature is
> kicked off.

Indeed, I now installed laptop-mode-tools and suddenly the 
HDA disappeared from the list of power consumers ..

I don't know *what* has changed in Debian/sid recently that this
not-saving became the default, but it happened, because I regularly
check with powertop and never saw the HDA before.

Anyway, thanks, back to normal.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
You're very sure of your facts, " he said at last, "I
couldn't trust the thinking of a man who takes the Universe
- if there is one - for granted.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy
