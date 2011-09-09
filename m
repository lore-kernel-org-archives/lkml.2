Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170Ab1IIJSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 05:18:25 -0400
Received: from server655-han.de-nserver.de ([85.158.177.45]:42937 "EHLO
	server655-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933134Ab1IIJSX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 05:18:23 -0400
References: <4E69A496.9040707@profihost.ag>
In-Reply-To: <4E69A496.9040707@profihost.ag>
Mime-Version: 1.0 (iPhone Mail 8H7)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <0A5D57A3-50CB-4AE2-90DE-EF6C9D8F0C55@profihost.ag>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "efault@gmx.de" <efault@gmx.de>
X-Mailer: iPhone Mail (8H7)
From: Stefan Priebe <s.priebe@profihost.ag>
Subject: Re: system freezing with 3.0.4
Date: Fri, 9 Sep 2011 11:18:15 +0200
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
X-User-Auth: Auth by s.priebe@profihost.ag through 80.187.110.255
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here a better sysrq w trigger output.

http://pastebin.com/JWjrbrh4

> Hi list,
> 
> here's an updated post of my one yesterday.
> 
> We've updated some systems from 2.6.32 to 3.0.4 vanilla kernel. Since then we're expecting freezes every now and then. All in memory apps are still working but nothing which reads or writes from or to disk (at least it seems like that).
> 
> If you're already conncted via ssh and running top suddenly idle is 99-100% and loads goes up to 500. I then cannot write to disk anymore. I've seen this for now on 2-5 of 20 servers i've updated. I can't believe they are all damaged. Also every night there comes another one where the same happens. Also running them on 2.6.32 again works fine.
> 
> Luckily i was able to trigger a sysrq on one machine fast enough:
> echo t >/proc/sysrq-trigger
> 
> sysrq output is attached
> 
> I hope somebody can help.
> 
> Please CC me i'm not on list.
> 
> Stefan
> 
> <sysrqtrigger.txt>
