Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab1LUHKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 02:10:54 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53121 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab1LUHKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 02:10:51 -0500
Date: Wed, 21 Dec 2011 07:10:39 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Dave Kleikamp <shaggy@kernel.org>,
        jfs-discussion@lists.sourceforge.net,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Mickler <florian@mickler.org>, davem@davemloft.net,
        linux-mm@kvack.org
Subject: Re: [Resend] 3.2-rc6+: Reported regressions from 3.0 and 3.1
Message-ID: <20111221071039.GH23916@ZenIV.linux.org.uk>
References: <201112210054.46995.rjw@sisk.pl>
 <CA+55aFzee7ORKzjZ-_PrVy796k2ASyTe_Odz=ji7f1VzToOkKw@mail.gmail.com>
 <4EF15F42.4070104@oracle.com>
 <CA+55aFx=B9adsTR=-uYpmfJnQgdGN+1aL0KUabH5bSY6YcwO7Q@mail.gmail.com>
 <alpine.LSU.2.00.1112202213310.3987@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1112202213310.3987@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 10:15:00PM -0800, Hugh Dickins wrote:

> Acked-by: Hugh Dickins <hughd@google.com>
> 
> from me (and add_to_page_cache_locked does the masking of inappropriate
> bits when passing on down, so no need to worry about that aspect).

I was grepping for possibilities of that hitting us right now...  OK,
rigth you are.

Acked-by: Al Viro <viro@zeniv.linux.org.uk>
