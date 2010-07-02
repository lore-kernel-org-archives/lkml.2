Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631Ab0GBNok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 09:44:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:40356 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab0GBNoi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 09:44:38 -0400
Subject: Re: reiserfs locking (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@lst.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>,
       Jeff Mahoney <jeffm@jeffreymahoney.com>
In-Reply-To: <20100702131248.GA5324@nowhere>
References: <20100702093451.GA3973@swordfish.minsk.epam.com>
	 <20100702131248.GA5324@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 02 Jul 2010 15:44:27 +0200
Message-ID: <1278078267.1917.254.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-02 at 15:12 +0200, Frederic Weisbecker wrote:
> 
> I don't think the deadlock can really happen, as we can't release the directory while
> we are reading it. Plus I guess we can't mmap a directory (someone correct me if
> I'm wrong).
> 

> Is there someone who could give me a hint here?

If its purely directories you can try and give directory inode locks a
different class.
