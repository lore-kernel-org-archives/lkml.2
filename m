Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab1DLDt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 23:49:58 -0400
Received: from ozlabs.org ([203.10.76.45]:59625 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756628Ab1DLDt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 23:49:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, lguest@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC][PATCH] virtio: 64 bit features
In-Reply-To: <20110411165525.GA1395@redhat.com>
References: <20110411165525.GA1395@redhat.com>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Tue, 12 Apr 2011 12:55:42 +0930
Message-ID: <87ei58cfrd.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Apr 2011 19:55:25 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> Extend features to 64 bit so we can use more
> transport bits.
> 
> Future patches add two new feature bits which would
> exhaust the supply of transport feature bits,
> so let's add bit 31 to tell the guest that
> there are now 64 worth of features.
> 
> For PCI this also changes the config layout.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

This was pretty much the way I imagined it would work.  We need a patch
to the spec and a lot of cross testing...

Thanks!
Rusty.
