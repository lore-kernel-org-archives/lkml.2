Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab2ATExg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 23:53:36 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:60734 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab2ATExf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 23:53:35 -0500
X-Greylist: delayed 1209 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jan 2012 23:53:35 EST
Date: Fri, 20 Jan 2012 13:33:24 +0900
From: Norbert Preining <preining@logic.at>
To: linux-kernel@vger.kernel.org
Subject: kworker thread eating CPU time in 3.3-rc1
Message-ID: <20120120043324.GA9929@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

(please cc)

today I switched from 3.2 to 3.3-rc1 and now I have permanently
2 kworker threads each eating up 10-20% CPU time, which seems a bit
exaggerated, comparted to all the rest at below or around 1%.
There is nothing really crazy running, just a gnome3 desktop, firefox,
nothing fancy.

Any idea where this might come from?

Please let me know if you need more information.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
HASSOP (n.)
The pocket down the back of an armchair used for storing two-shilling
bits and pieces of Lego.
			--- Douglas Adams, The Meaning of Liff
