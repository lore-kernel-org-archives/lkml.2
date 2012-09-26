Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab2IZRr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:47:29 -0400
Received: from wp118.webpack.hosteurope.de ([80.237.132.125]:37131 "EHLO
	wp118.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754171Ab2IZRr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:47:28 -0400
Date: Wed, 26 Sep 2012 19:47:22 +0200
From: Florian Dazinger <florian@dazinger.net>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        iommu <iommu@lists.linux-foundation.org>
Subject: Re: 3.6-rc7 boot crash + bisection
Message-ID: <20120926194722.3d95847e@brain.lan>
In-Reply-To: <20120926150407.GD10549@amd.com>
References: <20120924210348.5f50677b@brain.lan>
	<1348597970.28860.114.camel@bling.home>
	<20120925205420.0a07dea2@brain.lan>
	<1348602226.28860.132.camel@bling.home>
	<20120926010154.49cc2588@brain.lan>
	<20120926144345.GC10549@amd.com>
	<1348671121.28860.186.camel@bling.home>
	<20120926150407.GD10549@amd.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;florian@dazinger.net;1348681648;94923251;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wed, 26 Sep 2012 17:04:07 +0200
schrieb "Roedel, Joerg" <Joerg.Roedel@amd.com>:

> On Wed, Sep 26, 2012 at 08:52:01AM -0600, Alex Williamson wrote:
> > Assuming this works, it may be ok as a 3.7 fix, but if there was
> > actually more than one device behind the alias we'd expose them as
> > separate iommu groups.  I don't think that's what we want.  Maybe it
> > should at least get a pr_warn.  Thanks,
> 
> True, we need something more generic as the real fix. When Florian
> reports success I'll try to get this still into 3.6, otherwise to
> -stable.
> 
> 
> 	Joerg
> 

 ... updating to the newest BIOS revision does not make any difference, rc7 is crashing, rc7+patch is not, I definitely need this patch.
If there is more you want me to test, pls tell.

Florian
