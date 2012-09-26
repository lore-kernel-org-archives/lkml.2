Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab2IZQOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 12:14:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755760Ab2IZQOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 12:14:05 -0400
Message-ID: <1348676038.28860.190.camel@bling.home>
Subject: Re: 3.6-rc7 boot crash + bisection
From: Alex Williamson <alex.williamson@redhat.com>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: Florian Dazinger <florian@dazinger.net>, linux-kernel@vger.kernel.org,
        iommu <iommu@lists.linux-foundation.org>
Date: Wed, 26 Sep 2012 10:13:58 -0600
In-Reply-To: <20120926150407.GD10549@amd.com>
References: <20120924210348.5f50677b@brain.lan>
	 <1348597970.28860.114.camel@bling.home> <20120925205420.0a07dea2@brain.lan>
	 <1348602226.28860.132.camel@bling.home> <20120926010154.49cc2588@brain.lan>
	 <20120926144345.GC10549@amd.com> <1348671121.28860.186.camel@bling.home>
	 <20120926150407.GD10549@amd.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-26 at 17:04 +0200, Roedel, Joerg wrote:
> On Wed, Sep 26, 2012 at 08:52:01AM -0600, Alex Williamson wrote:
> > Assuming this works, it may be ok as a 3.7 fix, but if there was
> > actually more than one device behind the alias we'd expose them as
> > separate iommu groups.  I don't think that's what we want.  Maybe it
> > should at least get a pr_warn.  Thanks,
> 
> True, we need something more generic as the real fix. When Florian
> reports success I'll try to get this still into 3.6, otherwise to
> -stable.

Yes, 3.6 is what I meant to type.  Thanks,

Alex


