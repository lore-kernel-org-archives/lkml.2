Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab0JPDAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 23:00:40 -0400
Received: from mail.wdtv.com ([66.118.69.84]:53910 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab0JPDAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 23:00:39 -0400
From: Gene Heskett <gene.heskett@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Probably a repeat.
Date: Fri, 15 Oct 2010 23:00:34 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.35.7; KDE/4.5.2; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010152300.34879.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

Trying to build a 2.6.36-rc8, ends up here:

  Building modules, stage 2.
  MODPOST 1248 modules
ERROR: "dump_seek" [fs/binfmt_aout.ko] undefined!
ERROR: "dump_write" [fs/binfmt_aout.ko] undefined!

plus a couple section miss-matches, and of course it bailed out.  Next?

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Whenever a system becomes completely defined, some damn fool discovers
something which either abolishes the system or expands it beyond 
recognition.
