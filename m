Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab2GEMWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:22:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab2GEMWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:22:10 -0400
Date: Thu, 5 Jul 2012 15:22:25 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, amit.shah@redhat.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        rusty@rustcorp.com.au, avi@redhat.com
Subject: Re: [PATCH] MAINTAINERS: add kvm list for virtio components
Message-ID: <20120705122225.GA30572@redhat.com>
References: <1341482827-13195-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341482827-13195-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 12:07:07PM +0200, Paolo Bonzini wrote:
> The KVM list is followed by more people than the generic
> virtualization@lists.linux-foundation.org mailing list, and is
> already "de facto" the place where virtio patches are posted.

I have no data on the first statement (do you?) and I disagree with the
last statement, but have no objection to people adding kvm list as well.

> pv-ops still has no other lists than virtualization@lists.linux-foundation.org.
> However, pv-ops patches will likely touch Xen or KVM files as well and
> the respective mailing list will usually be reached as well.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

So pls please replace the 1st paragraph in the commit log with
"virtio changes are likely to affect many KVM users as virtio is
 the de-facto standard for PV devices under KVM". Otherwise ok.

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  MAINTAINERS |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 14bc707..e265f2e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7340,6 +7340,7 @@ F:	include/media/videobuf2-*
>  VIRTIO CONSOLE DRIVER
>  M:	Amit Shah <amit.shah@redhat.com>
>  L:	virtualization@lists.linux-foundation.org
> +L:	kvm@vger.kernel.org
>  S:	Maintained
>  F:	drivers/char/virtio_console.c
>  F:	include/linux/virtio_console.h
> @@ -7348,6 +7349,7 @@ VIRTIO CORE, NET AND BLOCK DRIVERS
>  M:	Rusty Russell <rusty@rustcorp.com.au>
>  M:	"Michael S. Tsirkin" <mst@redhat.com>
>  L:	virtualization@lists.linux-foundation.org
> +L:	kvm@vger.kernel.org
>  S:	Maintained
>  F:	drivers/virtio/
>  F:	drivers/net/virtio_net.c
> -- 
> 1.7.1
