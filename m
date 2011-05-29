Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab1E2XRC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 19:17:02 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49938 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab1E2XRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 19:17:00 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 30 May 2011 01:16:44 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: August Lilleaas <august@augustl.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Firewire: net: replacing deprecated
 __attribute__((packed)) with __packed
Message-ID: <20110530011644.2d83cb44@stein>
In-Reply-To: <BANLkTinoaAt4YamyDoOGbsDhCMBGZhz_rw@mail.gmail.com>
References: <1306688839-18732-1-git-send-email-august@augustl.com>
	<20110529234416.7f6f2d53@stein>
	<BANLkTinoaAt4YamyDoOGbsDhCMBGZhz_rw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 30 August Lilleaas wrote:
> On Sun, May 29, 2011 at 11:44 PM, Stefan Richter
> <stefanr@s5r6.in-berlin.de>wrote:
> 
> > Who deprecated it and why?
> >
> 
> To be frank, the motivation for this patch was a message from script/
> checkpatch.pl when scouring random files for warnings. (This is my first
> contribution to the kernel.)
> 
> Just did some much needed investigation though. It was deprecated for
> portability, specifically to avoid GCC specific code. See commit
> 82ddcb040570411fc2d421d96b3e69711c670328.

OK, thanks for the info.

> > Shouldn't you add "#include <linux/compiler.h>" now?
> >
> 
> You're right. I'll read up on updating patches and get at it.

I will just add it when I commit the patch.

(One way to update a patch is to make it the top commit, then edit files
and "git add ..." them as necessary, then "git commit --amend".  There are
other ways of course.)
-- 
Stefan Richter
-=====-==-== -=-= ====-
http://arcgraph.de/sr/
