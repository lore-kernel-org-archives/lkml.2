Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab2D0Xyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 19:54:46 -0400
Received: from na3sys010aog112.obsmtp.com ([74.125.245.92]:59589 "HELO
	na3sys010aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757255Ab2D0Xyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 19:54:45 -0400
MIME-Version: 1.0
In-Reply-To: <4F9ACFC4.6010002@xenotime.net>
References: <20120427161146.95422142968526faaff615d4@canb.auug.org.au> <4F9ACFC4.6010002@xenotime.net>
From: Roland Dreier <roland@purestorage.com>
Date: Fri, 27 Apr 2012 16:54:23 -0700
Message-ID: <CAL1RGDXJO8phXEvrqWAzwLNGWp+mDo6tAFUEDhsiyJd=951FKg@mail.gmail.com>
Subject: Re: inux-next: Tree for Apr 27 (infiniband/hw/ocrdma)
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 9:56 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> when IPV6 is not enabled:
>
> ERROR: "register_inet6addr_notifier" [drivers/infiniband/hw/ocrdma/ocrdma.ko] undefined!
> ERROR: "unregister_inet6addr_notifier" [drivers/infiniband/hw/ocrdma/ocrdma.ko] undefined!

Thanks, I'll take care of this (probably just wrap those calls in a
check if ipv6 is enabled).

 - R.
