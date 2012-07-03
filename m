Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933338Ab2GCS6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 14:58:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44613 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932678Ab2GCS6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 14:58:09 -0400
Date: Tue, 3 Jul 2012 20:58:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Calvin Walton <calvin.walton@kepstin.ca>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        shemminger@vyatta.com
Subject: Re: long boot delays caused by 070ad7e7 floppy change
Message-ID: <20120703185808.GM11413@one.firstfloor.org>
References: <20120702224648.GA20361@tassilo.jf.intel.com> <CA+55aFwre6s=orjUaNKJA=51Fc1mxu_XGX80Bex4Sn-=mWPx5Q@mail.gmail.com> <1341323230.3292.10.camel@nayuki.kepstin.ca> <CA+55aFyvzz3Lp9zeA6X+QMan0iZFWq_0Xd+ff_trnP1tpn2iJQ@mail.gmail.com> <1341337257.2406.1.camel@nayuki.kepstin.ca> <CA+55aFzOD33eWj0FQuZ7RWmF-yYwaeNB-9J-YY+mX4mwP7VXuA@mail.gmail.com> <CA+55aFwQqTAHNafGBXaoPCzVYw83OZvbG_hOYEDUxmuoMODO3Q@mail.gmail.com> <alpine.LNX.2.00.1207032008350.17304@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1207032008350.17304@pobox.suse.cz>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Calvin, Andi, could you please dump the value of UDP->timeout in 
> __reschedule_timeout(), please?


[    2.496493] calling  floppy_init+0x0/0xe46 @ 1
[    2.511303] floppy0: lock_fdc: -1 (out of 8)
[    2.511346] floppy0: __reschedule_timeout: setting timeout to 750
[    2.511372] floppy0: reschedule timeout lock fdc
[   22.501757] floppy0: reschedule timeout do wakeup
[   22.501784] floppy0: no floppy controllers found
[   22.501919] initcall floppy_init+0x0/0xe46 returned -19 after
19573258 usecs

-Andi
