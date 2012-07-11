Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210Ab2GKSen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 14:34:43 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51674 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754663Ab2GKSem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 14:34:42 -0400
Message-ID: <1342031676.3522.39.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH v4] virtio-scsi: hotplug support for virtio-scsi
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Cong Meng <mc@linux.vnet.ibm.com>, stefanha@linux.vnet.ibm.com,
        linuxram@us.ibm.com, senwang@linux.vnet.ibm.com, zwanp@cn.ibm.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Date: Wed, 11 Jul 2012 19:34:36 +0100
In-Reply-To: <4FF55C0C.4040309@redhat.com>
References: <1341479203-12058-1-git-send-email-mc@linux.vnet.ibm.com>
	 <4FF55C0C.4040309@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-05 at 11:19 +0200, Paolo Bonzini wrote:
> Il 05/07/2012 11:06, Cong Meng ha scritto:
> > This patch implements the hotplug support for virtio-scsi.
> > When there is a device attached/detached, the virtio-scsi driver will be
> > signaled via event virtual queue and it will add/remove the scsi device 
> > in question automatically.
> > 
> > v2: handle no_event event
> > v3: add handle event dropped, and typo fix
> > v4: Cancel event works when exit. Coding type fix.
> > 
> > Signed-off-by: Sen Wang <senwang@linux.vnet.ibm.com>
> > Signed-off-by: Cong Meng <mc@linux.vnet.ibm.com>
> 
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Actually, that should be Acked-by, since you're the maintainer of the
driver (it means I reviewed it + I approve it for upstream inclusion).

> > ---
> >  drivers/scsi/virtio_scsi.c  |  127 ++++++++++++++++++++++++++++++++++++++++++-
> >  include/linux/virtio_scsi.h |    9 +++
> >  2 files changed, 135 insertions(+), 1 deletions(-)

The next time, please run checkpatch on this.  You can ignore the
warnings about lines over 80 characters, but the braces issue is worth
paying attention to when that reflects the current style.

James


