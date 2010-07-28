Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab0G1KAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 06:00:44 -0400
Received: from mail.perches.com ([173.55.12.10]:2152 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754569Ab0G1KAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 06:00:42 -0400
Subject: Re: [Uclinux-dist-devel] [PATCH net-next] drivers/net/bfin_mac.c:
 Use  pr_fmt, netdev_<level>
From: Joe Perches <joe@perches.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>,
        uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
In-Reply-To: <AANLkTi=p=-ovBaqyqBdEW=W4E1ArWsiyUBwy37GtXOyu@mail.gmail.com>
References: <1280258531.24054.10.camel@Joe-Laptop.home>
	 <AANLkTi=p=-ovBaqyqBdEW=W4E1ArWsiyUBwy37GtXOyu@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 03:00:40 -0700
Message-ID: <1280311240.24054.103.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-28 at 03:50 -0400, Mike Frysinger wrote:
> On Tue, Jul 27, 2010 at 15:22, Joe Perches wrote:
> > $ ./scripts/checkpatch.pl -f drivers/net/bfin_mac.c | grep "^total:"
> > total: 2 errors, 25 warnings, 1723 lines checked
> > $ ./scripts/checkpatch.pl -f drivers/net/bfin_mac.c | grep "^total:"
> > total: 0 errors, 0 warnings, 1743 lines checked
> i dislike the mixing of whitespace and useful changes
> if they were split, and they worked, then i wouldnt have a problem with them

Is that a nak or a dislike?

Also, is Michael Hennerich actually the maintainer for bfin_mac?
He had been  listed as MAINTAINER for over a year but he hasn't
ever written or acked a patch for this file.

commit making Michael Hennerich bfin_mac MAINTAINER
$ git log -1 6c83429a
commit 6c83429a1c32c914dfb81939cc2ddece97e48294
Author: Mike Frysinger <vapier@gentoo.org>
Date:   Sun May 24 02:13:15 2009 -0400

    MAINTAINERS: update Blackfin items
    
    With Bryan Wu having moved on to another job, push the slack onto some
    other ADI lackeys.
    
    Signed-off-by: Mike Frysinger <vapier@gentoo.org>

$ ./scripts/get_maintainer.pl -f drivers/net/bfin_mac.c \
	--rolestats --git-since=5-years-ago --nol
Michael Hennerich <michael.hennerich@analog.com> (supporter:BLACKFIN EMAC DRIVER)
"David S. Miller" <davem@davemloft.net> (commit_signer:41/65=63%)
Jeff Garzik <jgarzik@redhat.com> (commit_signer:31/65=48%)
Bryan Wu <cooloney@kernel.org> (commit_signer:26/65=40%)
Mike Frysinger <vapier@gentoo.org> (commit_signer:20/65=31%)
Sonic Zhang <sonic.zhang@analog.com> (commit_signer:8/65=12%)



