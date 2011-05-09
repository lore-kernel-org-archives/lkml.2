Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab1EIGm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 02:42:59 -0400
Received: from ozlabs.org ([203.10.76.45]:52420 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671Ab1EIGm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 02:42:57 -0400
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
Subject: Re: [PATCH 3/3] virtio_ring: need_event api comment fix
In-Reply-To: <c8b6d8a8df4927826d0024fceeb68726c50d0b1a.1304605817.git.mst@redhat.com>
References: <cover.1304605816.git.mst@redhat.com> <c8b6d8a8df4927826d0024fceeb68726c50d0b1a.1304605817.git.mst@redhat.com>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Mon, 09 May 2011 15:29:43 +0930
Message-ID: <87y62gfm7k.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 May 2011 18:08:17 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> fix typo in a comment: size -> side
> 
> Reported-by: Stefan Hajnoczi <stefanha@gmail.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

I could smerge these together for you, but I *really* want benchmarks in
these commit messages.

Thanks,
Rusty.
PS. Was away last week, hence the delay on this...
