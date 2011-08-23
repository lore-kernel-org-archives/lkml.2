Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab1HWDx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 23:53:56 -0400
Received: from ozlabs.org ([203.10.76.45]:52109 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888Ab1HWDxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 23:53:40 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] virtio-net: Read MAC only after initializing MSI-X
In-Reply-To: <20110822083613.GA18556@redhat.com>
References: <1313225461-24458-1-git-send-email-levinsasha928@gmail.com> <20110819152335.GA19489@redhat.com> <87hb5a5m3x.fsf@rustcorp.com.au> <20110822083613.GA18556@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Tue, 23 Aug 2011 13:19:36 +0930
Message-ID: <87bovg4wj3.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Aug 2011 11:36:13 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> Yes. Or maybe 'WHEN' - since if MSI-X is disabled again, it moves back.
> Let's update the spec to make it clearer?

I left the language as is, but added a footnote at the end of the
sentence:

If MSI-X is enabled for the device, two additional fields immediately
follow this header:
[footnote: ie. once you enable MSI-X on the device, the other
           fields move. If you turn it off again, they move back!]

Thanks,
Rusty.
