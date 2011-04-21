Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab1DUPnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 11:43:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:41676 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab1DUPnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 11:43:06 -0400
Subject: Re: [PATCH v2] intel-iommu: Fix use after release during device
 attach
From: David Woodhouse <dwmw2@infradead.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Chris Wright <chrisw@sous-sol.org>,
        kvm <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Avi Kivity <avi@redhat.com>
Date: Thu, 21 Apr 2011 16:42:58 +0100
In-Reply-To: <1303396097.3050.4.camel@x201>
References: <4CCFB84F.6050102@web.de>
	 <201011021531.22886.sheng@linux.intel.com> <4CDFA96D.1060301@web.de>
	 <4D01E677.5070702@siemens.com> <20101210184402.GE4040@sequoia.sous-sol.org>
	 <4D22F9A4.3050807@web.de>  <4DB023C7.5070007@siemens.com>
	 <1303396097.3050.4.camel@x201>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.0 (3.0.0-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1303400579.23521.2.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 15:28 +0100, Alex Williamson wrote:
> I've been wondering the exact same thing.  My last patch took weeks of
> prodding, finally went into the maintainer's tree without
> acknowledgment, and there's hardly been any activity there to suggest
> a pull request for 2.6.39 is going to happen.  David, are you still
> interested in maintaining this code?  Thanks, 

Yes, sorry, I've been somewhat snowed under with various things.

This patch has been in my tree for a while, and I've just merged one
more patch which is outstanding and sent Linus a pull request.
 
-- 
dwmw2

