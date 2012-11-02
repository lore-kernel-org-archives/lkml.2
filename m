Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934001Ab2KBRx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:53:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44836 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260Ab2KBRxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:53:55 -0400
Date: Fri, 2 Nov 2012 10:53:50 -0700
From: Tejun Heo <tj@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Kay Sievers <kay@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: setting up CDB filters in udev (was Re: [PATCH v2 0/3] block:
 add queue-private command filter, editable via sysfs)
Message-ID: <20121102175350.GB27843@mtj.dyndns.org>
References: <20121025180045.GL11442@htj.dyndns.org>
 <1657557410.1945557.1351190120407.JavaMail.root@redhat.com>
 <20121031212241.GZ2945@htj.dyndns.org>
 <5093DD5E.6030808@redhat.com>
 <20121102165123.GB3823@mtj.dyndns.org>
 <509407B7.3030904@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <509407B7.3030904@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Paolo.

On Fri, Nov 02, 2012 at 06:49:43PM +0100, Paolo Bonzini wrote:
> > No rule is really absolute.  To me, it seems the suggested in-kernel
> > per-device command code filter is both too big for the given problem
> 
> Is it?  150 lines of code?  The per-class filters would share the first
> two patches with this series, add a long list of commands to filter, and
> the ioctl would be on top of that.

It's not really about the lines of code.  It adds a new userland
visible interface.  As for the "long" list of commands, it depends on
how you write it but even if it's textually long it's still very
simple in terms of actual complexity.

> > while being too limited for much beyond that.
> 
> What are the use cases beyond these?  AFAIK these were the first two in
> ten years or so...

If this is such a cold area, why do we want do anything other than the
simplest possible?

> > So, if we can get away
> > with adding an ioctl, I personally think that would be a better
> > approach.
> 
> I would really prefer to get a green light from Jens/James for per-class
> filters in the kernel (which are worth a few hundred lines of data)
> before implementing that.

Sure, Jens, James?  Guys, come on.

Thanks.

-- 
tejun
