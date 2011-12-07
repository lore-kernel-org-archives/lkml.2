Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab1LGH2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 02:28:14 -0500
Received: from ozlabs.org ([203.10.76.45]:38161 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab1LGH2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 02:28:13 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Amit Shah <amit.shah@redhat.com>,
        Virtualization List <virtualization@lists.linux-foundation.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH v4 00/12] virtio: s4 support
In-Reply-To: <cover.1323199985.git.amit.shah@redhat.com>
References: <cover.1323199985.git.amit.shah@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 07 Dec 2011 17:54:29 +1030
Message-ID: <87wra8j13m.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  7 Dec 2011 01:18:38 +0530, Amit Shah <amit.shah@redhat.com> wrote:
> Hi,
> 
> These patches add support for S4 to virtio (pci) and all drivers.

Dumb meta-question: why do we want to hibernate virtual machines?

I figure there's a reason, but it seems a bit weird :)

Thanks,
Rusty.
