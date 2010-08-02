Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab0HBIDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 04:03:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:35438 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271Ab0HBID3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 04:03:29 -0400
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        "stepanm@codeaurora.org" <stepanm@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "dwalker@codeaurora.org" <dwalker@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100802074812.GM24084@amd.com>
References: <ea4bbdecc271f7fa5749d09645f38c0d.squirrel@www.codeaurora.org>
	 <bad58db98c165a61860827d4e720acf8.squirrel@www.codeaurora.org>
	 <20100729123512Y.fujita.tomonori@lab.ntt.co.jp>
	 <201007291026.55928.arnd@arndb.de> <1280546124.1902.30.camel@pasglop>
	 <20100802074812.GM24084@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Aug 2010 18:03:02 +1000
Message-ID: <1280736182.1902.55.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-02 at 09:48 +0200, Roedel, Joerg wrote:
> > Hrm, indeed I just noticed that. Pretty gross... it should definitly
> be
> > renamed, is will caused endless confusion with unrelated iommu.h and
> > iommu_* interfaces which represent something different.
> 
> The first direction to go should be trying to unify all the different
> iommu* interfaces into the iommu-api. The generic api will definitly
> need to be extended for that, but since it is an in-kernel interface
> thats no problem. 

Well, I suppose I'm the de-facto candidate to take care of the powerpc
side then :-)

I don't have the bandwidth right now, but I'll try to have a look when
time permits.

Cheers,
Ben.


