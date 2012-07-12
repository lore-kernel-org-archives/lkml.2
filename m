Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030534Ab2GLKhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 06:37:31 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36981 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932983Ab2GLKh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 06:37:29 -0400
MIME-Version: 1.0
In-Reply-To: <1341479203-12058-1-git-send-email-mc@linux.vnet.ibm.com>
References: <1341479203-12058-1-git-send-email-mc@linux.vnet.ibm.com>
Date: Thu, 12 Jul 2012 11:37:27 +0100
Message-ID: <CAJSP0QUUHC3ye0QWBGO3hBJ5RnsUVHumfVNUoMj+OZJDJEprPA@mail.gmail.com>
Subject: Re: [PATCH v4] virtio-scsi: hotplug support for virtio-scsi
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Cong Meng <mc@linux.vnet.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, stefanha@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org, senwang@linux.vnet.ibm.com,
        zwanp@cn.ibm.com, linuxram@us.ibm.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 10:06 AM, Cong Meng <mc@linux.vnet.ibm.com> wrote:
> This patch implements the hotplug support for virtio-scsi.
> When there is a device attached/detached, the virtio-scsi driver will be
> signaled via event virtual queue and it will add/remove the scsi device
> in question automatically.
>
> v2: handle no_event event
> v3: add handle event dropped, and typo fix
> v4: Cancel event works when exit. Coding type fix.
>
> Signed-off-by: Sen Wang <senwang@linux.vnet.ibm.com>
> Signed-off-by: Cong Meng <mc@linux.vnet.ibm.com>
> ---
>  drivers/scsi/virtio_scsi.c  |  127 ++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/virtio_scsi.h |    9 +++
>  2 files changed, 135 insertions(+), 1 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
