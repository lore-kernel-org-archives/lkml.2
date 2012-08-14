Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab2HNW3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 18:29:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41489 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab2HNW3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 18:29:17 -0400
Date: Wed, 15 Aug 2012 00:29:15 +0200
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, Fengguang Wu <fengguang.wu@intel.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Kamal Mostafa <kamal@canonical.com>,
        "Peter M. Petrakis" <peter.petrakis@canonical.com>,
        Dann Frazier <dann.frazier@canonical.com>,
        Massimo Morana <massimo.morana@canonical.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: mq: INFO: possible circular locking dependency detected
Message-ID: <20120814222915.GP7122@quack.suse.cz>
References: <501D0093.2090108@gmail.com>
 <20120805170856.GC8954@localhost>
 <20120807050412.GA23960@localhost>
 <20120807063955.GX23464@ZenIV.linux.org.uk>
 <20120808071738.GA20090@localhost>
 <20120808075439.GA20645@localhost>
 <20120814220927.GN7122@quack.suse.cz>
 <20120814221331.GK23464@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120814221331.GK23464@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 14-08-12 23:13:31, Al Viro wrote:
> On Wed, Aug 15, 2012 at 12:09:27AM +0200, Jan Kara wrote:
> >   OK, this is a theoretical deadlock since mqueue (virtual) filesystem cannot
> > really be frozen. But we should convert the mqueue code to deal with new
> > lock ordering of i_mutex and mnt_want_write() anyway to make lockdep happy
> > if anything... That file somehow escaped my conversion efforts. I'll send a
> > fix tomorrow.
> 
> It's fixed in commit 98d11eacde966041ac7357d99d4079db7173dd40 (in vfs.git)
  OK, I see. Thanks!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
