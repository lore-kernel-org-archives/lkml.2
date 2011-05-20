Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933621Ab1ETNWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:22:10 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:33012 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab1ETNWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:22:08 -0400
X-Greylist: delayed 2541 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 May 2011 09:22:08 EDT
Date: Fri, 20 May 2011 21:39:45 +0900
From: Norbert Preining <preining@logic.at>
To: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: output on external video projector broken with 2.6.39 with intel
Message-ID: <20110520123945.GC4022@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

(please cc)

laptop: sony vaio vgn-z11
graphics hardware: GM45
X: 7.6 (Debian: 1:7.6+6)
X intel driver: 2:15.0 (Debian: 2:2.15.0-3)
system: Debian sid up2date

I regularly build kernels from git, but haven't tried a video projector
for some time now. I found that in recent kernels I have problems with
the output to the external screen.

After inital connection everything works and I have a BIG virtual
screen covering both units. Then I want to switch it to 
	Same image on both screens
and at that time one of the screens, most of the times the external
ones, sometimes both, fall into pieces with vertical stripes and
colors.

Waiting 25sec my program (xrandr or gnome screen props) resets the
setting and I am back to two screens showing independent images.

Is that a driver issue, a kernel issue, or anything else?

If you need more information, dmesg, X logs, or I should try some
patches, whatever please let me know.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
GLENWHILLY (n. Scots)
A small tartan pouch worn beneath the kilt during the thistle-harvest.
			--- Douglas Adams, The Meaning of Liff
