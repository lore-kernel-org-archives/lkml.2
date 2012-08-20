Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab2HTPNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:13:49 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:52320 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756671Ab2HTPNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:13:46 -0400
X-Greylist: delayed 560 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Aug 2012 11:13:46 EDT
Date: Mon, 20 Aug 2012 08:04:05 -0700 (PDT)
From: Jakob Bornecrantz <jakob@vmware.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Message-ID: <790319256.19256264.1345475045195.JavaMail.root@vmware.com>
In-Reply-To: <20120820144438.6255.39723.stgit@localhost.localdomain>
Subject: Re: [PATCH] drm: stop vmgfx driver explosion
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [85.225.38.204]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - GC18 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: Alan Cox <alan@linux.intel.com>
> 
> If you do a page flip with no flags set then event is NULL. If event
> is NULL then the vmw_gfx driver likes to go digging into NULL and
> extracts NULL->base.file_priv.
> 
> On a modern kernel with NULL mapping protection it's just another
> oops, without it there are some "intriguing" possibilities.
> 
> What it should do is an open question but that for the driver owners
> to sort out.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>

Thanks Alan!

Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>

I think CC stable is in order.

Cheers, Jakob.
