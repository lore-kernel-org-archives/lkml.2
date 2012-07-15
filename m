Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab2GOT2w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 15:28:52 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:38832 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750905Ab2GOT2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 15:28:44 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19/MzMDUVJ/JzLRAGXpiSUoyAMGiUKDLT01/3eHbi
	p0U9ELGnqg6Rj1
Message-ID: <500319E9.8010001@gmx.de>
Date: Sun, 15 Jul 2012 21:28:41 +0200
From: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120625 Thunderbird/13.0
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: 3.5-rcX: wakeup after s2ram doesn't work after a longer sleep time
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My ThinkPad T400 (Gentoo Linux booted from an external USB drive) does
not wake up after s2ram, if the  sleep time was longer than about 1 hour.
I'm unsure whether this started after 3.5-rc5, at least with -rc7 I
observed this now several times. Unfortunately it is not 100% reproduceable.

3.4.x works flawlessly.

Any idea whether a particular commit could be the culprit ? (Bisecting
such an issue is a night mare)


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

