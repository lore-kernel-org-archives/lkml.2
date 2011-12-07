Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab1LGHpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 02:45:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219Ab1LGHpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 02:45:04 -0500
Date: Wed, 7 Dec 2011 13:14:56 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/12] virtio: s4 support
Message-ID: <20111207074456.GD4651@amit-x200.redhat.com>
References: <cover.1323199985.git.amit.shah@redhat.com>
 <87wra8j13m.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wra8j13m.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Wed) 07 Dec 2011 [17:54:29], Rusty Russell wrote:
> On Wed,  7 Dec 2011 01:18:38 +0530, Amit Shah <amit.shah@redhat.com> wrote:
> > Hi,
> > 
> > These patches add support for S4 to virtio (pci) and all drivers.
> 
> Dumb meta-question: why do we want to hibernate virtual machines?

Not a dumb question at all :)

But that doesn't mean I can't give a dumb answer: "Because We Can".

> I figure there's a reason, but it seems a bit weird :)

Well, there is one reason right now: migrating storage along with
VMs.  The guest needs to sync all data to the disk before the target
host accesses the image file.  One way to make sure guests don't access
the disk is by adding a new guest command to stop disk accesses.
However, we already have one way of making guests stop doing whatever
they are by putting them into S4 state, and then waking them up on the
remote, with them thinking nothing about them has changed.

(Did I manage to make this sound desirable after the answer above? :)

	     Amit
