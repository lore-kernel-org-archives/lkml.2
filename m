Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab1DUQPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 12:15:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198Ab1DUQPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 12:15:10 -0400
Subject: Re: [PATCH v2] intel-iommu: Fix use after release during device
 attach
From: Alex Williamson <alex.williamson@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Chris Wright <chrisw@sous-sol.org>,
        kvm <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Avi Kivity <avi@redhat.com>
In-Reply-To: <1303400579.23521.2.camel@i7.infradead.org>
References: <4CCFB84F.6050102@web.de>
	 <201011021531.22886.sheng@linux.intel.com> <4CDFA96D.1060301@web.de>
	 <4D01E677.5070702@siemens.com> <20101210184402.GE4040@sequoia.sous-sol.org>
	 <4D22F9A4.3050807@web.de>  <4DB023C7.5070007@siemens.com>
	 <1303396097.3050.4.camel@x201>  <1303400579.23521.2.camel@i7.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 10:14:56 -0600
Message-ID: <1303402496.3050.6.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 16:42 +0100, David Woodhouse wrote:
> On Thu, 2011-04-21 at 15:28 +0100, Alex Williamson wrote:
> > I've been wondering the exact same thing.  My last patch took weeks of
> > prodding, finally went into the maintainer's tree without
> > acknowledgment, and there's hardly been any activity there to suggest
> > a pull request for 2.6.39 is going to happen.  David, are you still
> > interested in maintaining this code?  Thanks, 
> 
> Yes, sorry, I've been somewhat snowed under with various things.
> 
> This patch has been in my tree for a while, and I've just merged one
> more patch which is outstanding and sent Linus a pull request.

Thanks David, I know you've been busy lately.

Alex

