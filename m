Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab1EUCec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 22:34:32 -0400
Received: from ozlabs.org ([203.10.76.45]:37291 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755141Ab1EUCeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: Re: [PATCHv2 02/14] virtio ring: inline function to check for events
In-Reply-To: <16ce853af7a80d0f7cb0c1118ba8e19adc184ad0.1305846412.git.mst@redhat.com>
References: <cover.1305846412.git.mst@redhat.com> <16ce853af7a80d0f7cb0c1118ba8e19adc184ad0.1305846412.git.mst@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Sat, 21 May 2011 11:59:40 +0930
Message-ID: <87y620u6p7.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011 02:10:27 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> With the new used_event and avail_event and features, both
> host and guest need similar logic to check whether events are
> enabled, so it helps to put the common code in the header.
> 
> Note that Xen has similar logic for notification hold-off
> in include/xen/interface/io/ring.h with req_event and req_prod
> corresponding to event_idx + 1 and new_idx respectively.
> +1 comes from the fact that req_event and req_prod in Xen start at 1,
> while event index in virtio starts at 0.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Applied.

Thanks,
Rusty.
