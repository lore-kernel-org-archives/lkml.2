Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab2A2W5c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 17:57:32 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:55605 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab2A2W5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 17:57:30 -0500
Date: Mon, 30 Jan 2012 07:57:28 +0900
From: Norbert Preining <preining@logic.at>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Regression 3.2 -> 3.3-rc1 sound hda-intel broken
Message-ID: <20120129225728.GA26166@gamma.logic.tuwien.ac.at>
References: <20120124012633.GA18436@gamma.logic.tuwien.ac.at> <s5hmx96lggt.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hmx96lggt.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Takashi,

On So, 29 Jan 2012, Takashi Iwai wrote:
> Could you check whether reverting hda_intel.c to 3.2 fixes the
> problem?  If not, try to revert all files in sound/pci/hda/*.[ch]
> to3.2, i.e. for checking whether it's a regression in hd-audio driver
> or somewhere else.

I posted to the bug tracker just now, but with later git kernels
(2d3c7efa5, 2 days ago), I don't see that phenomenon anymore, so
I suggest to close this bug.

If you still are interested in tests, please let me know.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
TRANTLEMORE (vb.) To make a noise like a train crossing a set of
points.
			--- Douglas Adams, The Meaning of Liff
