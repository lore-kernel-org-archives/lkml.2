Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab1LGKpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 05:45:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597Ab1LGKpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 05:45:04 -0500
Date: Wed, 7 Dec 2011 12:44:59 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Amit Shah <amit.shah@redhat.com>,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/12] virtio: s4 support
Message-ID: <20111207104459.GR12507@redhat.com>
References: <cover.1323199985.git.amit.shah@redhat.com>
 <87wra8j13m.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wra8j13m.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 05:54:29PM +1030, Rusty Russell wrote:
> On Wed,  7 Dec 2011 01:18:38 +0530, Amit Shah <amit.shah@redhat.com> wrote:
> > Hi,
> > 
> > These patches add support for S4 to virtio (pci) and all drivers.
> 
> Dumb meta-question: why do we want to hibernate virtual machines?
> 
For instance you want to hibernate your laptop while it is running a virtual
machine. You can pause them of course, but then time will be incorrect
inside a guest after resume.

> I figure there's a reason, but it seems a bit weird :)
> 
> Thanks,
> Rusty.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--
			Gleb.
