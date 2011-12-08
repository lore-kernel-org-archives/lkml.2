Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab1LHL4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 06:56:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773Ab1LHL4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 06:56:49 -0500
Date: Thu, 8 Dec 2011 17:26:40 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/12] virtio: s4 support
Message-ID: <20111208115640.GE23531@amit-x200.redhat.com>
References: <cover.1323199985.git.amit.shah@redhat.com>
 <87wra8j13m.fsf@rustcorp.com.au>
 <20111207074456.GD4651@amit-x200.redhat.com>
 <87liqoirgm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87liqoirgm.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Wed) 07 Dec 2011 [21:22:41], Rusty Russell wrote:
> On Wed, 7 Dec 2011 13:14:56 +0530, Amit Shah <amit.shah@redhat.com> wrote:
> > On (Wed) 07 Dec 2011 [17:54:29], Rusty Russell wrote:
> > > I figure there's a reason, but it seems a bit weird :)
> > 
> > Well, there is one reason right now: migrating storage along with
> > VMs.  The guest needs to sync all data to the disk before the target
> > host accesses the image file.
> 
> I don't see why.  Sure, if qemu (or whatever) is doing buffering, it
> needs to flush that.  It doesn't, last I looked, it just maps to
> read/write.
> 
> What am I missing?

I'm sorry, I got confused.  The external file migration Gleb
mentioned, though, is something that libvirt uses right now and causes
guest time craziness so S4 is one (and natural) way to solve it.

		Amit
