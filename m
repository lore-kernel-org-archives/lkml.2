Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab1EUCe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 22:34:26 -0400
Received: from ozlabs.org ([203.10.76.45]:57598 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331Ab1EUCeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 22:34:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Shirley Ma <xma@us.ibm.com>, lguest@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Krishna Kumar <krkumar2@in.ibm.com>,
        Tom Lendacky <tahm@linux.vnet.ibm.com>, steved@us.ibm.com,
        habanero@linux.vnet.ibm.com
Subject: Re: [PATCHv2 03/14] virtio_ring: support event idx feature
In-Reply-To: <960f3e3b260844011b004c81dbda0661c977b79a.1305846412.git.mst@redhat.com>
References: <cover.1305846412.git.mst@redhat.com> <960f3e3b260844011b004c81dbda0661c977b79a.1305846412.git.mst@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Sat, 21 May 2011 12:01:13 +0930
Message-ID: <87vcx4u6mm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011 02:10:44 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> Support for the new event idx feature:
> 1. When enabling interrupts, publish the current avail index
>    value to the host to get interrupts on the next update.
> 2. Use the new avail_event feature to reduce the number
>    of exits from the guest.

Applied.

Thanks,
Rusty.
