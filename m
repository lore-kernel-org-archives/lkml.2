Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab2H3IEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 04:04:48 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37812 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab2H3IEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 04:04:43 -0400
Date: Thu, 30 Aug 2012 08:13:42 +0100
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kvm@vger.kernel.org, mst@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/5] Multiqueue virtio-scsi
Message-ID: <20120830071342.GA6221@stefanha-thinkpad.localdomain>
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 01:54:12PM +0200, Paolo Bonzini wrote:
> this series adds multiqueue support to the virtio-scsi driver, based
> on Jason Wang's work on virtio-net.  It uses a simple queue steering
> algorithm that expects one queue per CPU.  LUNs in the same target always
> use the same queue (so that commands are not reordered); queue switching
> occurs when the request being queued is the only one for the target.
> Also based on Jason's patches, the virtqueue affinity is set so that
> each CPU is associated to one virtqueue.

Reviewed-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
