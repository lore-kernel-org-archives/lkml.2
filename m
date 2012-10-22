Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab2JVSTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 14:19:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33259 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab2JVSTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 14:19:53 -0400
Date: Mon, 22 Oct 2012 11:19:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jay Fenlason <fenlason@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] prevent CVE-2012-2372 rds-ping causes kernel panic
Message-ID: <20121022181949.GA10077@kroah.com>
References: <20121022181253.GA13736@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121022181253.GA13736@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 02:12:54PM -0400, Jay Fenlason wrote:
> If you use rds-ping of the local IP address of some Infiniband HCAs
> (QLogic, possibly others) the machine will panic with a BUG_ON due to
> an overly restrictive check.  Loosen the restriction a bit
> 
> This should have gotten sent a while ago (it was first noticed in
>  https://bugzilla.redhat.com/show_bug.cgi?id=803936
> and patched in kernel-2.6.32-275.el6) but I got confused about its
> embargo status and lost it.
> 
> Signed-off-by: Jay Fenlason <fenlason@redhat.com>
> 
> diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
