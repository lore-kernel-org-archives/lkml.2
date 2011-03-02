Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab1CBE7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 23:59:07 -0500
Received: from cantor.suse.de ([195.135.220.2]:45046 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630Ab1CBE7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 23:59:05 -0500
Date: Tue, 1 Mar 2011 23:59:23 -0500
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Evgeniy Dushistov <dushistov@mail.ru>, linux-fsdevel@vger.kernel.org,
        linux-x25@vger.kernel.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Max Vozeler <max@vozeler.com>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        netdev@vger.kernel.org, Nick Bowler <nbowler@elliptictech.com>,
        Nick Piggin <npiggin@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>
Subject: Re: [PATCH 0/7] Final BKL removal, take 2
Message-ID: <20110302045923.GA28214@suse.de>
References: <1299021191-17961-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299021191-17961-1-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 12:13:04AM +0100, Arnd Bergmann wrote:
> This is the set of patches that remain from
> my previous submission one month ago. I've
> dropped the ones that have either gone into
> linux-next or got a sufficient number of
> Acked-by:s so I put them into my own tree.
> 
> I've updated the usbip, hpfs, ufs and appletalk
> patches according to the feedback I got.
> 
> If possible, I'd like the three networking patches
> to go through the net-next tree, and the two
> staging patches through the staging tree. I'll
> add the other ones to my own series if I hear
> no objections.

I'll queue up the staging patches in the staging-next tree in a day or
so, thanks for digging them up.

greg k-h
