Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab1EXQaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 12:30:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab1EXQaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 12:30:06 -0400
Subject: Re: [PATCH] pci, dmar: flush IOTLB before exit domain
From: Alex Williamson <alex.williamson@redhat.com>
To: "Woodhouse, David" <david.woodhouse@intel.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Kalle Valo <kvalo@adurom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai.lu@oracle.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
In-Reply-To: <1306235059.7218.16.camel@i7.infradead.org>
References: <4DC34B21.9040203@oracle.com>
	 <1304952530.30435.16.camel@i7.infradead.org>
	 <1305558798.3146.48.camel@x201>  <1305661262.29268.27.camel@x201>
	 <1305683845.29268.34.camel@x201>
	 <1306235059.7218.16.camel@i7.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 10:29:13 -0600
Message-ID: <1306254553.3100.62.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 12:04 +0100, Woodhouse, David wrote:
> On Tue, 2011-05-17 at 19:57 -0600, Alex Williamson wrote:
> > 
> > David, what do you think of this instead?  Thanks,
> 
> Yes, that makes more sense. Thanks.
> 
> Sorry for not getting this in before the 2.6.39 release. I'm merging it
> now (with Cc: stable) and will push to Linus in a couple of days.

Thanks David.  Please also review and include the domain unlinking patch
I just sent.  It should go in stable too.  Thanks,

Alex

