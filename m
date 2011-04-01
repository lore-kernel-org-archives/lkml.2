Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab1DACwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 22:52:09 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:41563 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab1DACwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 22:52:07 -0400
X-Greylist: delayed 2469 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Mar 2011 22:52:07 EDT
Date: Fri, 1 Apr 2011 11:10:55 +0900
From: Norbert Preining <preining@logic.at>
To: linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net
Subject: Lenovo Thinkpad Edge: suspend to ram works, but wake up not
Message-ID: <20110401021055.GB6071@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I got a new laptop, Lenovo Thinkpad Edge (intel , intel graphic)
and I am running 2.6.39-rc1 on it (but tried also 2.6.38).

Suspend to RAM, either by pm-suspend or by echo "mem" >/sys/..
works, both wiht  running or from a recovery session where nothing
else is running.

But wake-up hangs the machine. The video comes back, I see the last
lines I typed before I suspended, but after that no keypress nor
anything else (Sysrq) does work, but 4sec-hard-off. No traces in the
log files.

ANy suggestions how to proceed and debug that?

Thanks a lot and all the best

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
ARDSCALPSIE (n.)
Excuse made by rural Welsh hairdresser for completely massacring your
hair.
			--- Douglas Adams, The Meaning of Liff
