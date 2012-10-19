Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215Ab2JSJSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 05:18:38 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45555 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753795Ab2JSJSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 05:18:36 -0400
Date: Fri, 19 Oct 2012 10:18:11 +0100
From: Will Deacon <will.deacon@arm.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Thomas Meyer <thomas@m3y3r.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        airlied <airlied@linux.ie>, "David S. Miller" <davem@davemloft.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: "read_current_timer" undefined!
Message-ID: <20121019091811.GB4582@mudshark.cambridge.arm.com>
References: <1350562575.1270.3.camel@localhost.localdomain>
 <5080F0EF.5040100@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5080F0EF.5040100@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 07:19:27AM +0100, Alexander Holler wrote:
> Hello,
> 
> Am 18.10.2012 14:16, schrieb Thomas Meyer:
> 
> > ERROR: "read_current_timer" [drivers/gpu/drm/udl/udl.ko] undefined!
> > ERROR: "read_current_timer" [crypto/tcrypt.ko] undefined!
> 
> There is already a long thread about that, along with patches:
> 
> https://lkml.org/lkml/2012/10/9/393
> 
> If you need a patch for 3.6, here is what I did before I found the above 
> thread:

Arnd sent an updated pull request here:

  http://lists.infradead.org/pipermail/linux-arm-kernel/2012-October/124756.html

but it was a reply to a previous pull, so it may have been missed. Could you
pull that for -rc2 please Russell?

Thanks,

Will
