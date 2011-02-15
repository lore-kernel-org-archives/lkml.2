Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab1BOQ4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 11:56:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209Ab1BOQ4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 11:56:31 -0500
Date: Tue, 15 Feb 2011 16:56:18 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Tao Ma <tm@tao.ma>,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH][RFC] dm: Do not open log and cow device
	read-write for read-only mappings
Message-ID: <20110215165618.GA28164@agk-dp.fab.redhat.com>
Mail-Followup-To: Tejun Heo <tj@kernel.org>, Milan Broz <mbroz@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>,
	device-mapper development <dm-devel@redhat.com>,
	Jens Axboe <axboe@kernel.dk>, Tao Ma <tm@tao.ma>,
	linux-kernel@vger.kernel.org
References: <4D5A6EF4.3030905@redhat.com> <20110215124629.GF5825@agk-dp.fab.redhat.com> <20110215152033.GK3160@htj.dyndns.org> <20110215154625.GG5825@agk-dp.fab.redhat.com> <20110215155018.GM3160@htj.dyndns.org> <4D5AA45C.7050600@redhat.com> <20110215161228.GN3160@htj.dyndns.org> <4D5AAB8F.50901@redhat.com> <20110215164128.GQ3160@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110215164128.GQ3160@htj.dyndns.org>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 05:41:28PM +0100, Tejun Heo wrote:
> That said, maybe -EROFS is the better fit.  I really have no idea.
> Maybe we should just revert and leave rw accesses to ro block devices
> alone.
 
I'd agree that the change to enforce readonly devs is a desirable change
to make.  But we're still discovering exactly what things it breaks and
as well as further kernel patches some userspace changes seem
unavoidable.  Personally I'd prefer it if this change went back into
linux-next to give us more time to prepare for it cleanly.  It's
unfortunate none of us picked up on these problems sooner.

Alasdair

