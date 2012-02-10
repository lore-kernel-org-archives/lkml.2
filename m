Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759058Ab2BJLAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 06:00:19 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48164 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758839Ab2BJLAR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 06:00:17 -0500
MIME-Version: 1.0
In-Reply-To: <1328440562-19425-1-git-send-email-pbonzini@redhat.com>
References: <1328440562-19425-1-git-send-email-pbonzini@redhat.com>
Date: Fri, 10 Feb 2012 11:00:14 +0000
Message-ID: <CAJSP0QV5bRzwPMfQTyMj34kiJ+to8Z7hJQxJrK5edG1dAHCr4Q@mail.gmail.com>
Subject: Re: [PATCH v5 0/3] virtio-scsi driver
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Mike Christie <michaelc@cs.wisc.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 5, 2012 at 11:15 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> This is the first implementation of the virtio-scsi driver, a virtual
> HBA that will be supported by KVM.  It implements a subset of the spec,
> in particular it does not implement asynchronous notifications for either
> LUN reset/removal/addition or CD-ROM media events, but it is already
> functional and usable.
>
> Other matching bits:
>
> - spec at http://people.redhat.com/pbonzini/virtio-spec.pdf
>
> - QEMU implementation at git://github.com/bonzini/qemu.git,
>  branch virtio-scsi
>
> Please review.  Getting this in 3.3 is starting to look like wishful thinking,
> but the possibility of regressions is obviously zero so I'm still dreaming.
> Otherwise, that would be 3.4.

Reviewed-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
