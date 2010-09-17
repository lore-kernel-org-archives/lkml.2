Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab0IQNcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:32:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51449 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab0IQNck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:32:40 -0400
Date: Fri, 17 Sep 2010 09:32:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Anton Altaparmakov <aia21@cam.ac.uk>, Jan Kara <jack@suse.cz>,
        codalist@TELEMANN.coda.cs.cmu.edu, autofs@linux.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Christoph Hellwig <hch@infradead.org>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Petr Vandrovec <vandrove@vc.cvut.cz>, Anders Larsen <al@alarsen.net>,
        Evgeniy Dushistov <dushistov@mail.ru>, Ingo Molnar <mingo@elte.hu>,
        netdev@vger.kernel.org, Samuel Ortiz <samuel@sortiz.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andrew Hendry <andrew.hendry@gmail.com>
Subject: Re: Remaining BKL users, what to do
Message-ID: <20100917133231.GA9411@infradead.org>
References: <201009161632.59210.arnd@arndb.de>
 <20100916150459.GA8437@quack.suse.cz>
 <16843727-8A3D-48FF-9021-E0AD99C23E18@cam.ac.uk>
 <201009171245.41930.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009171245.41930.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 12:45:41PM +0200, Arnd Bergmann wrote:
> ncpfs: replace BKL with lock_super

Err, no.  lock_super is just as much on it's way out as the BKL.  We've
managed to move it down from the VFS into a few remaining filesystems
and now need to get rid of those users.  Please don't add any new ones.

