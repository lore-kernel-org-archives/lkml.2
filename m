Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827Ab2DJORh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 10:17:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424Ab2DJORg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 10:17:36 -0400
Date: Tue, 10 Apr 2012 16:45:22 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] adding tracepoints to vhost
Message-ID: <20120410134522.GC18899@redhat.com>
References: <20120410025327.49693.93562.stgit@amd-6168-8-1.englab.nay.redhat.com>
 <CAJSP0QWA1z6_YQe9hhpG7bCyZQarmU5NXbHsLGTL_zPTk3dOUA@mail.gmail.com>
 <20120410124250.GB29808@redhat.com>
 <CAEH94Li0==w=AUKd5WCPMcqxLh=+N6bKttOwrE8y-xuOyPt_QA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEH94Li0==w=AUKd5WCPMcqxLh=+N6bKttOwrE8y-xuOyPt_QA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 09:10:48PM +0800, Zhi Yong Wu wrote:
> >> Perhaps this can replace the vhost log feature?  I'm not sure if
> >> tracepoints support the right data types but it seems like vhost
> >> debugging could be done using tracing with less code.
> >>
> >> Stefan
> >
> > vhost log is not a debugging tool, it logs memory accesses for
> > migration.
> Great, it is very appreciated if there's some docs about this

About what? vhost logging? See the comment near the
definition of VHOST_SET_LOG_BASE in vhost.h

> > _______________________________________________
> > Virtualization mailing list
> > Virtualization@lists.linux-foundation.org
> > https://lists.linuxfoundation.org/mailman/listinfo/virtualization
> 
> 
> 
> -- 
> Regards,
> 
> Zhi Yong Wu
