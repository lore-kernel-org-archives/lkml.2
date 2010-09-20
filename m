Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab0ITBZR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 21:25:17 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59931 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754792Ab0ITBZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 21:25:14 -0400
X-Sasl-enc: CHAO+2HuBdcDWCjJEqtSsIxD3u/1xkhRzxF/Izviiw7G 1284945912
Subject: Re: [autofs] Remaining BKL users, what to do
From: Ian Kent <raven@themaw.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: codalist@TELEMANN.coda.cs.cmu.edu, autofs@linux.kernel.org,
        Samuel Ortiz <samuel@sortiz.org>, Jan Kara <jack@suse.cz>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        netdev@vger.kernel.org, Anders Larsen <al@alarsen.net>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Christoph Hellwig <hch@infradead.org>,
        Petr Vandrovec <vandrove@vc.cvut.cz>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        linux-fsdevel@vger.kernel.org, Evgeniy Dushistov <dushistov@mail.ru>,
        Ingo Molnar <mingo@elte.hu>, Andrew Hendry <andrew.hendry@gmail.com>,
        linux-media@vger.kernel.org
In-Reply-To: <201009161632.59210.arnd@arndb.de>
References: <201009161632.59210.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Sep 2010 09:25:02 +0800
Message-ID: <1284945902.3095.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-16 at 16:32 +0200, Arnd Bergmann wrote:
> The big kernel lock is gone from almost all code in linux-next, this is
> the status of what I think will happen to the remaining users:
> 

...

> fs/autofs:
> 	Pretty much dead, replaced by autofs4. I'd suggest moving this
> 	to drivers/staging in 2.6.37 and letting it die there.

Not sure that's what we need.
What actually needs to happen is that autofs4 needs to be renamed to
autofs.

Ian



