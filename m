Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab0IBKPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 06:15:18 -0400
Received: from thunk.org ([69.25.196.29]:41638 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab0IBKPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 06:15:14 -0400
Date: Wed, 1 Sep 2010 20:18:59 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: "K. Richard Pixley" <rich@noir.com>
Cc: Mike Fedyk <mfedyk@mikefedyk.com>, Josef Bacik <josef@redhat.com>,
        Tomasz Chmielewski <mangoo@wpkg.org>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, hch@infradead.org, gg.mariotti@gmail.com,
        "Justin P. Mattock" <justinmattock@gmail.com>, mjt@tls.msk.ru
Subject: Re: BTRFS: Unbelievably slow with kvm/qemu
Message-ID: <20100902001859.GA4930@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"K. Richard Pixley" <rich@noir.com>,
	Mike Fedyk <mfedyk@mikefedyk.com>, Josef Bacik <josef@redhat.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, hch@infradead.org,
	gg.mariotti@gmail.com,
	"Justin P. Mattock" <justinmattock@gmail.com>, mjt@tls.msk.ru
References: <4C7AB645.5090804@wpkg.org>
 <20100830001441.GA838@dhcp231-156.rdu.redhat.com>
 <4C7BD569.9000702@noir.com>
 <AANLkTin-BZvqCChXEmsDfjhVmRmJLaoaudnuFL6EXZQx@mail.gmail.com>
 <4C7D7B14.9020008@noir.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7D7B14.9020008@noir.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 02:58:44PM -0700, K. Richard Pixley wrote:
>  On 20100831 14:46, Mike Fedyk wrote:
> >There is little reason not to use duplicate metadata.  Only small
> >files (less than 2kb) get stored in the tree, so there should be no
> >worries about images being duplicated without data duplication set at
> >mkfs time.
> My benchmarks show that for my kinds of data, btrfs is somewhat
> slower than ext4, (which is slightly slower than ext3 which is
> somewhat slower than ext2), when using the defaults, (ie, duplicate
> metadata).
> 
> It's a hair faster than ext2, (the fastest of the ext family), when
> using singleton metadata.  And ext2 isn't even crash resistant while
> btrfs has snapshots.

I'm really, really curious.  Can you describe your data and your
workload in detail?  You mentioned "continuous builders"; is this some
kind of tinderbox setup?

						- Ted
