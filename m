Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab2JANLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:11:41 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33608 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab2JANLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:11:39 -0400
Message-ID: <50699682.9020804@redhat.com>
Date: Mon, 01 Oct 2012 15:11:30 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, JBottomley@parallels.com,
        kvm@vger.kernel.org, linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] virtio-scsi fixes for 3.6
References: <1343309288-32615-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1343309288-32615-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 26/07/2012 15:28, Paolo Bonzini ha scritto:
> James,
> 
> patch 1 fixes scanning of LUNs whose number is greater than 255.  QEMU
> passes a max_lun of 16383 (because it uses SAM numbering) but in Linux
> it must become 32768 (because LUNs above 255 are "relocated" to 16640).
> Patch 2 is a resubmission of the patch for online resizing of virtio-scsi
> LUNs, which needs to be rebased.
> 
> LUNs above 255 now work for all of scanning, hotplug, hotunplug and
> resize.
> 
> Thanks,
> 
> Paolo
> 
> Paolo Bonzini (2):
>   virtio-scsi: fix LUNs greater than 255
>   virtio-scsi: support online resizing of disks
> 
>  drivers/scsi/virtio_scsi.c  |   37 +++++++++++++++++++++++++++++++++++--
>  include/linux/virtio_scsi.h |    2 ++
>  2 files changed, 37 insertions(+), 2 deletions(-)
> 

Ping, are these patches going into 3.7?

Paolo
