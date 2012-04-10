Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645Ab2DJLky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 07:40:54 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62172 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2DJLkw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 07:40:52 -0400
MIME-Version: 1.0
In-Reply-To: <20120410025327.49693.93562.stgit@amd-6168-8-1.englab.nay.redhat.com>
References: <20120410025327.49693.93562.stgit@amd-6168-8-1.englab.nay.redhat.com>
Date: Tue, 10 Apr 2012 12:40:50 +0100
Message-ID: <CAJSP0QWA1z6_YQe9hhpG7bCyZQarmU5NXbHsLGTL_zPTk3dOUA@mail.gmail.com>
Subject: Re: [PATCH 0/2] adding tracepoints to vhost
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mst@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 3:58 AM, Jason Wang <jasowang@redhat.com> wrote:
> To help in vhost analyzing, the following series adding basic tracepoints to
> vhost. Operations of both virtqueues and vhost works were traced in current
> implementation, net code were untouched. A top-like satistics displaying script
> were introduced to help the troubleshooting.
>
> TODO:
> - net specific tracepoints?
>
> ---
>
> Jason Wang (2):
>      vhost: basic tracepoints
>      tools: virtio: add a top-like utility for displaying vhost satistics
>
>
>  drivers/vhost/trace.h   |  153 ++++++++++++++++++++
>  drivers/vhost/vhost.c   |   17 ++
>  tools/virtio/vhost_stat |  360 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 528 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/vhost/trace.h
>  create mode 100755 tools/virtio/vhost_stat

Perhaps this can replace the vhost log feature?  I'm not sure if
tracepoints support the right data types but it seems like vhost
debugging could be done using tracing with less code.

Stefan
