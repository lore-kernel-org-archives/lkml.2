Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab2GCRpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 13:45:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44529 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab2GCRpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 13:45:08 -0400
Date: Tue, 3 Jul 2012 19:45:00 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Calvin Walton <calvin.walton@kepstin.ca>, Andi Kleen <andi@firstfloor.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        shemminger@vyatta.com
Subject: Re: long boot delays caused by 070ad7e7 floppy change
Message-ID: <20120703174500.GK11413@one.firstfloor.org>
References: <20120702224648.GA20361@tassilo.jf.intel.com> <CA+55aFwre6s=orjUaNKJA=51Fc1mxu_XGX80Bex4Sn-=mWPx5Q@mail.gmail.com> <1341323230.3292.10.camel@nayuki.kepstin.ca> <CA+55aFyvzz3Lp9zeA6X+QMan0iZFWq_0Xd+ff_trnP1tpn2iJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyvzz3Lp9zeA6X+QMan0iZFWq_0Xd+ff_trnP1tpn2iJQ@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Sorry for the delay. Here's the output on my system with floppy=debug
and Linus' debug patch:


[    2.480521] calling  floppy_init+0x0/0xe46 @ 1
[    2.495325] floppy0: lock_fdc: -1 (out of 8)
[    2.495369] floppy0: reschedule timeout lock fdc
[   22.501736] floppy0: reschedule timeout do wakeup
[   22.501762] floppy0: no floppy controllers found
[   22.501896] initcall floppy_init+0x0/0xe46 returned -19 after
19588875 usecs


-- 
ak@linux.intel.com -- Speaking for myself only.
