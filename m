Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab2LVWzs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 17:55:48 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:46419 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab2LVWzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 17:55:46 -0500
Date: Sun, 23 Dec 2012 07:55:43 +0900
From: Norbert Preining <preining@logic.at>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: dire state of rtl8192se driver in 3.7
Message-ID: <20121222225543.GA21544@gamma.logic.tuwien.ac.at>
References: <20121222150909.GA3979@gamma.logic.tuwien.ac.at> <50D5E194.3050503@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50D5E194.3050503@lwfinger.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Larry,, hi all

On Sa, 22 Dez 2012, Larry Finger wrote:
> It is not that no one cares; however, your attitude does nothing to 
> induce me to work on this problem. The facts are not needed "to make 

Aehm, ... after my initial report you asked me several more questions,
which I answered within a few hours. After that no as in 0 response,
although I pinged back a few times.

So am I supposed to deduce from 0 reactions that anyone is interested?

> people happy", they are necessary to try to reproduce the problem. If I 
> cannot make it happen here, then I cannot fix it. Also, remember that I 

Disagree. I am involved in tracking down a nasty regression in the intel 
drm driver, which the intel people can *not* reproduce, but several
other people, and after long trials and patches and converse it is 
starting to look much better.

> am a volunteer. I get nothing from Realtek but starting code of varying 
> quality and some sample chips. At least my versions do not crash your 

Ok, that is a problem I understand. If this is the case, that it is
a single volunteer caring for the code, then I see a real problem.
(And I also will try to stay away from rtl wlan cards on my next laptop)

> I have never tested forcing a reset on the chip the way you did. I am not 
> surprised that bad things happen.

But the DMAR item I also reported points to a real problem I guess.

> From some of the material that you report, it appears that you have an 
> 802.11n connection using WPA1 encryption. (More of those pesky details!) 

WPA PSK, yes. I don't know the difference between WPA2 and WPA, though.

Best wishes, and merry christmas

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
`This must be Thursday,' said Arthur to himself, sinking
low over his beer, `I never could get the hang of
Thursdays.'
                 --- Arthur, on what was to be his last Thursday on Earth.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy
