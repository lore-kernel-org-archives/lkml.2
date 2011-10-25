Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab1JYDl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 23:41:57 -0400
Received: from ozlabs.org ([203.10.76.45]:56269 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756309Ab1JYDlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 23:41:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/1] [virt] virtio-blk: Use ida to allocate disk index
In-Reply-To: <4EA537AA.3090804@kernel.dk>
References: <1306913069-23637-1-git-send-email-dwu@redhat.com> <87mxi1xfz0.fsf@rustcorp.com.au> <4DEF744D.9040702@redhat.com> <87mxhrgba6.fsf@rustcorp.com.au> <20110609091433.GB11773@htj.dyndns.org> <4DF0A374.6090504@redhat.com> <20111019101220.GE25794@redhat.com> <20111024100238.GA27444@redhat.com> <4EA537AA.3090804@kernel.dk>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 25 Oct 2011 11:37:27 +1030
Message-ID: <87vcrdq3ow.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Oct 2011 12:02:18 +0200, Jens Axboe <axboe@kernel.dk> wrote:
> On 2011-10-24 12:02, Michael S. Tsirkin wrote:
> > On Wed, Oct 19, 2011 at 12:12:20PM +0200, Michael S. Tsirkin wrote:
> > Rusty, any opinion on merging this for 3.2?
> > I expect merge window will open right after the summit,
> 
> I can toss it into for-3.2/drivers, if there's consensus to do that now.

I'd like to see the final patch... we got the new simplified ida stuff
in, so I assume it uses that?

But assume silence from me means consent: it's obviously the Right
Thing.

Thanks,
Rusty.
