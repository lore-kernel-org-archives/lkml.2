Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab2ARUDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 15:03:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:47761 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756565Ab2ARUDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 15:03:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="108424777"
Subject: Re: [GIT PULL] slave-dmaengine updates
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Dan <dan.j.williams@intel.com>, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <CA+55aFyR7hKoeffHY6VYw-29pii+NVgsH2aFKU3YfW1-kFUtMg@mail.gmail.com>
References: <1326726380.1540.112.camel@vkoul-udesk3>
	 <CA+55aFyR7hKoeffHY6VYw-29pii+NVgsH2aFKU3YfW1-kFUtMg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Jan 2012 01:33:54 +0530
Message-ID: <1326917034.1540.185.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-17 at 18:41 -0800, Linus Torvalds wrote:
> On Mon, Jan 16, 2012 at 7:06 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> >
> > Here is the slave-dmaengine updates which include a new DMA engine API
> > for 2D interleaved transfers along with fixes for slave dma_tranfer
> > direction along with usual fixes and updates on bunch of the slave dma
> > drivers.
> 
> Ok, please verify my conflict resolution. It all looked pretty
> trivial, but affected code that I don't know nor can I even
> test-compile.
The resolution look fine to me. I have built and didn't find any issues.

Thanks
-- 
~Vinod

