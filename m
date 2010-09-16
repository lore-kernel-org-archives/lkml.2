Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab0IPQKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 12:10:12 -0400
Received: from de01.mail.all-tld.net ([195.140.232.8]:64205 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab0IPQKK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 12:10:10 -0400
Date: Thu, 16 Sep 2010 18:09:10 +0200
From: Anders Larsen <al@alarsen.net>
Subject: Re: Remaining BKL users, what to do
To: Arnd Bergmann <arnd@arndb.de>
Cc: codalist@TELEMANN.coda.cs.cmu.edu, autofs@linux.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Christoph Hellwig <hch@infradead.org>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Petr Vandrovec <vandrove@vc.cvut.cz>, Jan Kara <jack@suse.cz>,
        Evgeniy Dushistov <dushistov@mail.ru>, Ingo Molnar <mingo@elte.hu>,
        netdev@vger.kernel.org, Samuel Ortiz <samuel@sortiz.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andrew Hendry <andrew.hendry@gmail.com>
References: <201009161632.59210.arnd@arndb.de>
In-Reply-To: <201009161632.59210.arnd@arndb.de> (from arnd@arndb.de on Thu
	Sep 16 16:32:59 2010)
X-Mailer: Balsa 2.3.14
Message-Id: <1284653350l.20726l.1l@i-dmzi_al.realan.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-16 16:32:59, Arnd Bergmann wrote:
> The big kernel lock is gone from almost all code in linux-next, this is
> the status of what I think will happen to the remaining users:

> fs/qnx4:
> 	Should be easy to fix, there are only a few places in the code that
> 	use the BKL. Anders?

Will do.

Cheers
Anders

