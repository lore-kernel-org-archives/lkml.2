Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab2AaDVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 22:21:05 -0500
Received: from mail.wdtv.com ([66.118.69.84]:56139 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571Ab2AaDVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 22:21:03 -0500
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jan 2012 22:21:03 EST
From: Gene Heskett <gene.heskett@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: isolcpus question
Date: Mon, 30 Jan 2012 22:13:39 -0500
User-Agent: KMail/1.13.7 (Linux/2.6.38.8-pclos2.pae.bfs; KDE/4.6.5; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201302213.39672.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Which is, is there a isolcpus troubleshooting tool?

I have an app that is supposed to use the 2nd cpu on a 2 core atom system 
all by itself, and its insisting on using cpu0 when the boot command line 
has "isolcpus=1" appended to it, and apparently I am the only one with the 
problem, its working for about 200-500 others running the same software.

Cheers & thanks to anyone who can toss me a clue, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
My web page: <http://coyoteden.dyndns-free.com:85/gene>
There are three things men can do with women: love them, suffer for them,
or turn them into literature.
		-- Stephen Stills
