Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab1EUCeF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 22:34:05 -0400
Received: from ozlabs.org ([203.10.76.45]:59366 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958Ab1EUCeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: Re: [PATCHv2 01/14] virtio: event index interface
In-Reply-To: <995d19795d84a76f9836f4d9484fb4ef8eae36e9.1305846412.git.mst@redhat.com>
References: <cover.1305846412.git.mst@redhat.com> <995d19795d84a76f9836f4d9484fb4ef8eae36e9.1305846412.git.mst@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Sat, 21 May 2011 11:59:21 +0930
Message-ID: <871uzsvla6.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011 02:10:17 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> Define a new feature bit for the guest and host to utilize
> an event index (like Xen) instead if a flag bit to enable/disable
> interrupts and kicks.

Applied.

Thanks,
Rusty.
