Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758659Ab2DJMmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 08:42:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755557Ab2DJMml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 08:42:41 -0400
Date: Tue, 10 Apr 2012 15:42:51 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/2] adding tracepoints to vhost
Message-ID: <20120410124250.GB29808@redhat.com>
References: <20120410025327.49693.93562.stgit@amd-6168-8-1.englab.nay.redhat.com>
 <CAJSP0QWA1z6_YQe9hhpG7bCyZQarmU5NXbHsLGTL_zPTk3dOUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJSP0QWA1z6_YQe9hhpG7bCyZQarmU5NXbHsLGTL_zPTk3dOUA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 12:40:50PM +0100, Stefan Hajnoczi wrote:
> On Tue, Apr 10, 2012 at 3:58 AM, Jason Wang <jasowang@redhat.com> wrote:
> > To help in vhost analyzing, the following series adding basic tracepoints to
> > vhost. Operations of both virtqueues and vhost works were traced in current
> > implementation, net code were untouched. A top-like satistics displaying script
> > were introduced to help the troubleshooting.
> >
> > TODO:
> > - net specific tracepoints?
> >
> > ---
> >
> > Jason Wang (2):
> >      vhost: basic tracepoints
> >      tools: virtio: add a top-like utility for displaying vhost satistics
> >
> >
> >  drivers/vhost/trace.h   |  153 ++++++++++++++++++++
> >  drivers/vhost/vhost.c   |   17 ++
> >  tools/virtio/vhost_stat |  360 +++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 528 insertions(+), 2 deletions(-)
> >  create mode 100644 drivers/vhost/trace.h
> >  create mode 100755 tools/virtio/vhost_stat
> 
> Perhaps this can replace the vhost log feature?  I'm not sure if
> tracepoints support the right data types but it seems like vhost
> debugging could be done using tracing with less code.
> 
> Stefan

vhost log is not a debugging tool, it logs memory accesses for
migration.
