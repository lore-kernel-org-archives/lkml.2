Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306Ab2CBJoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 04:44:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:43728 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345Ab2CBJoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 04:44:07 -0500
Message-ID: <4F509658.1010709@kernel.dk>
Date: Fri, 02 Mar 2012 10:43:52 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH] block: fix __blkdev_get and add_disk race condition
References: <20120222165948.GA12961@redhat.com> <20120229145710.GB20516@redhat.com>
In-Reply-To: <20120229145710.GB20516@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29/2012 03:57 PM, Stanislaw Gruszka wrote:
> On Wed, Feb 22, 2012 at 05:59:49PM +0100, Stanislaw Gruszka wrote:
>> I use the script to verify patch fixing oops in sd_revalidate_disk
>> http://marc.info/?l=linux-scsi&m=132935572512352&w=2
>> Without Jun'ichi Nomura patch titled "Fix NULL pointer dereference in
>> sd_revalidate_disk" or this one, script easily crash kernel within
>> a few seconds.
> 
> Jens could you pick up both patches for 3.3 ? Both are actually a -stable
> fixes, despite they are not marked so, perhaps we should repost patches
> with that mark?

Both are now queued up, and I marked both as stable as well.

-- 
Jens Axboe

