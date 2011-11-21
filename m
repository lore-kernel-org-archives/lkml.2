Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab1KUFVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 00:21:55 -0500
Received: from ozlabs.org ([203.10.76.45]:44163 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab1KUFVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 00:21:52 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, Amit Shah <amit.shah@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio-pci: make reset operation safer
In-Reply-To: <20111117154114.GA31281@redhat.com>
References: <20111117154114.GA31281@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 21 Nov 2011 15:15:50 +1030
Message-ID: <87obw69j7l.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Nov 2011 17:41:15 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> virtio pci device reset actually just does an I/O
> write, which in PCI is really posted, that is it
> can complete on CPU before the device has received it.

Thanks, applied.  Because it's a theoretical issue, I've not cc'd
stable.

Thanks,
Rusty.
