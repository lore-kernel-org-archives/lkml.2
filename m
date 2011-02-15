Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab1BOKLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 05:11:33 -0500
Received: from ozlabs.org ([203.10.76.45]:46236 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148Ab1BOKLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 05:11:32 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] virtio: use __GFP_NOWARN for try_fill_recv in virtnet_poll
Date: Tue, 15 Feb 2011 20:41:29 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-generic; KDE/4.5.1; i686; ; )
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20110215093527.GB8341@tiehlicka.suse.cz>
In-Reply-To: <20110215093527.GB8341@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102152041.29179.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Feb 2011 08:05:27 pm Michal Hocko wrote:
> Hi,
> we have started seeing a lot of allocator messages complaining about
> failed allocations from virtnet_poll in soft IRQ. Could you consider the
> following patch, please?

Do we really want to silence this?  Isn't warning about it kind of the
point?  Your network is probably sucking if this happens...

Cheers,
Rusty.

