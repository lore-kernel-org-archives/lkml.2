Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547Ab2IFDB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 23:01:59 -0400
Received: from ozlabs.org ([203.10.76.45]:53847 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185Ab2IFDAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 23:00:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Stratos Psomadakis <psomas@cslab.ece.ntua.gr>,
        "David S. Miller" <davem@davemloft.net>, lguest@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH] virtio: support reserved vqs
In-Reply-To: <20120905184745.GA15861@redhat.com>
References: <20120905184745.GA15861@redhat.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 06 Sep 2012 12:11:50 +0930
Message-ID: <874nnbj2j5.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:

> virtio network device multiqueue support reserves
> vq 3 for future use (useful both for future extensions and to make it
> pretty - this way receive vqs have even and transmit - odd numbers).
> Make it possible to skip initialization for
> specific vq numbers by specifying NULL for name.
> Document this usage as well as (existing) NULL callback.
>
> Drivers using this not coded up yet, so I simply tested
> with virtio-pci and verified that this patch does
> not break existing drivers.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

This seems sane.  Applied.

Thanks,
Rusty.
