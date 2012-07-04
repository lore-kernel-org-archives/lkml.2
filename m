Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830Ab2GDG5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 02:57:11 -0400
Received: from ozlabs.org ([203.10.76.45]:42572 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240Ab2GDG5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 02:57:07 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: Re: [PATCH] virtio-blk: allow toggling host cache between writeback and writethrough
In-Reply-To: <1341321577-24435-1-git-send-email-pbonzini@redhat.com>
References: <1341321577-24435-1-git-send-email-pbonzini@redhat.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 04 Jul 2012 15:25:38 +0930
Message-ID: <87a9zgvzmt.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  3 Jul 2012 15:19:37 +0200, Paolo Bonzini <pbonzini@redhat.com> wrote:
> This patch adds support for the new VIRTIO_BLK_F_CONFIG_WCE feature,
> which exposes the cache mode in the configuration space and lets the
> driver modify it.  The cache mode is exposed via sysfs.
> 
> Even if the host does not support the new feature, the cache mode is
> visible (thanks to the existing VIRTIO_BLK_F_WCE), but not modifiable.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Applied, thanks!

Cheers,
Rusty.
