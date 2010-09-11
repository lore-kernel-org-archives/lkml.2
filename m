Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab0IKAr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 20:47:57 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:41430 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723Ab0IKAr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 20:47:56 -0400
Date: Sat, 11 Sep 2010 09:47:54 +0900
From: Norbert Preining <preining@logic.at>
To: Andy Isaacson <adi@hexapodia.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: after closing the lid and reopening it the screen remains blank
Message-ID: <20100911004754.GA20442@gamma.logic.tuwien.ac.at>
References: <20100909224117.GA30000@gamma.logic.tuwien.ac.at> <20100910184751.GA17794@hexapodia.org> <20100910234448.GB9848@gamma.logic.tuwien.ac.at> <20100911003459.GW23291@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100911003459.GW23291@hexapodia.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On Fr, 10 Sep 2010, Andy Isaacson wrote:
> > I never said that it has anything to do with suspend to ram.
> 
> Ah, sorry for misunderstanding.  My GM45 system is configured to
> automatically S2R on lid close so I tend to conflate the two...

Mine, too, but not when running on AC.

> Do try the current tip and/or describe which post-rc3 kernel fails for

current tip works fine. It seems that I was hit by one of the fixes
I found in the git log fixed after the build I did 
(drm/i915: Prevent double dpms on, or drm/i915: Clear the vblank status 
bit before polling for the next vblank)

> Thanks for reporting the regression, it'll be good to get it fixed ASAP.

Seems to be already fixed. Sorry for not testing the tip first.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
MOLESBY (n.)
The kind of family that drives to the seaside and then sits in the car
with all the windows closed, reading the Sunday Express and wearing
sidcups (q.v.)
			--- Douglas Adams, The Meaning of Liff
