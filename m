Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962Ab1FBDzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 23:55:39 -0400
Received: from ozlabs.org ([203.10.76.45]:45275 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab1FBDzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 23:55:36 -0400
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
Subject: Re: [PATCH RFC 1/3] virtio_ring: add capacity check API
In-Reply-To: <8014f898ca6b768d7be626b83c617a1e84adfeb9.1306921434.git.mst@redhat.com>
References: <cover.1306921434.git.mst@redhat.com> <8014f898ca6b768d7be626b83c617a1e84adfeb9.1306921434.git.mst@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 02 Jun 2011 11:41:50 +0930
Message-ID: <87sjrthti1.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jun 2011 12:49:46 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> Add API to check ring capacity. Because of the option
> to use indirect buffers, this returns the worst
> case, not the normal case capacity.

Can we drop the silly "add_buf() returns capacity" hack then?

Thanks,
Rusty.
