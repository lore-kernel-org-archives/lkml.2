Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab0DIQkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 12:40:16 -0400
Received: from ams-iport-2.cisco.com ([144.254.224.141]:39467 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab0DIQkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 12:40:13 -0400
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Apr 2010 12:40:13 EDT
Authentication-Results: ams-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgBAObyvkuQ/uCWe2dsb2JhbACbOxUBAQsLIgYcokyZI4UJBIMk
X-IronPort-AV: E=Sophos;i="4.52,178,1270425600"; 
   d="scan'208";a="5393653"
From: Tom Lyon <pugs@lyon-about.com>
To: Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 1/1] uio_pci_generic: extensions to allow access for non-privileged processes
Date: Fri, 9 Apr 2010 09:27:43 -0700
User-Agent: KMail/1.9.9
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com
References: <201003311708.38961.pugs@lyon-about.com> <201003311712.36105.pugs@lyon-about.com> <20100409090855.GF8750@8bytes.org>
In-Reply-To: <20100409090855.GF8750@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004090927.44157.pugs@lyon-about.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mea culpa. 

On Friday 09 April 2010 02:08:55 am Joerg Roedel wrote:
> Btw. This patch posting is broken. It suffers from line-wraps which make
> it impossible to apply as-is. I was able to fix it but please consider
> this in your next posting.
> 
> On Wed, Mar 31, 2010 at 05:12:35PM -0700, Tom Lyon wrote:
> 
> > --- linux-2.6.33/drivers/uio/uio_pci_generic.c	2010-02-24 
> > 10:52:17.000000000 -0800
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Unexpected line-wrap.
> 
> I also got some whitespace warnings when trying to apply it. Please make
> sure you fix this in the next version too.
> 
> Thanks,
> 
> 	Joerg
> 
> 


