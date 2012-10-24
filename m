Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161472Ab2JXWpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:45:33 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:54624 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161237Ab2JXWpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:45:32 -0400
Date: Wed, 24 Oct 2012 15:45:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH 3/3] Drivers: hv: Get rid of hv_ringbuffer_cleanup()
Message-ID: <20121024224528.GA30009@kroah.com>
References: <1350073335-10575-1-git-send-email-kys@microsoft.com>
 <1350073363-10614-1-git-send-email-kys@microsoft.com>
 <1350073363-10614-3-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350073363-10614-3-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 01:22:43PM -0700, K. Y. Srinivasan wrote:
> hv_ringbuffer_cleanup() is an empty function; get rid of it.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reported-by: Jason Wang <jasowang@redhat.com>
> Acked-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/hv/channel.c      |    4 ----
>  drivers/hv/hyperv_vmbus.h |    1 -
>  drivers/hv/ring_buffer.c  |   11 -----------
>  3 files changed, 0 insertions(+), 16 deletions(-)

That's nice, but this patch causes build failures, so I can't accept it.

Please test your patches better (hint, a simple 'git grep' would have
worked here...)

greg k-h
