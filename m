Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab0E2LXK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 07:23:10 -0400
Received: from webmail01.domeneshop.no ([194.63.248.8]:41870 "EHLO
	webmail01.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab0E2LXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 07:23:06 -0400
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 May 2010 07:23:06 EDT
Content-Disposition: inline
Content-Transfer-Encoding: binary
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MIME::Lite 3.01 (F2.74; T1.18; A1.74; B3.07; Q3.07)
From: uwaysi.bin.kareem@paradoxuncreated.com
To: linux-kernel@vger.kernel.org
Subject: linux-kernel@vger.kernel.org
Date: Sat, 29 May 2010 13:22:57 +0200
X-Remote-Address: 91.186.70.220
X-User-Agent: Opera/9.63 (Windows NT 5.1; U; en) Presto/2.1.1
X-Mailer: Domeneshop webmail 1.07 (2008-04-23)
X-Moam-Version: 0.93
Message-Id: <E1OIK81-0005ME-8H@webmail01.domeneshop.no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hmm, yes. Some typos there. Alhamdulillah (Praised Be God), for the correction. I do not have a good spellingchecker installed at the moment, and english is not my native language.

The patch is still very interesting though, I have also tried it on 2.6.34, where jitter is somewhat lower than 2.6.33.
For users of opengl-application, it is purely a benefit to increase the interrupt timer, and I have noticed no performance degradation (with opengl-applications) by doing so.

If the patch should not be working with future versions of the kernel, a simple edit of linuxkernel/kernel/Kconfig.hz, replacing 1000 with 3956 should do.


Randy Dunlap: Hi, What CPU architectures or platforms did you test this on? Were any other kernel changes needed?

Tested only on my Core2 duo. No other changes needed.


Valdis Kletnieks: Why 3956, and why better than 1000:

As stated the exact value 3956, fits a profile of "where the human senses register the most information".


The value may still iterate, as I am trying it on different kernels, and patches. However 3956 have been used here for a few months, without being changed.

As I am working out a few tweaks to reduce jitter, sporadic and more regular, I may also change the value.

However I think there is not so much more I can do, ATM, to reduce or change jitter behaviour. I have made a little script that changes some scheduling types, and installed a minimal linux-OS, for personal use, where I am optimizing it for my own senses, and therefore yours. :) Enjoy the fruits of this labour, if you want to be playing opengl games at it's best, (and particulary now, that the halflife series, is likely to come to linux. ! :)  - Much more enjoyable than anything running under closed source OS's, that's for sure. Overcommercialism subjecting man to inferior products, and so forth.

Peace Be With You
- Uwaysi.

