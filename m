Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab1EXWtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 18:49:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:54836 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987Ab1EXWtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 18:49:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,264,1304319600"; 
   d="scan'208";a="8049793"
From: Andi Kleen <andi@firstfloor.org>
To: Daniel Haid <d.haid@gogi.tv>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Question about iommu on x86_64 and radeon driver.
References: <6ac3f6faad655602b767aa14b355e982@admin.gogi.tv>
	<20110523220536.GB11961@dumpdata.com>
	<756073831c36e0404199a4e8239bcb70@admin.gogi.tv>
Date: Tue, 24 May 2011 15:48:26 -0700
In-Reply-To: <756073831c36e0404199a4e8239bcb70@admin.gogi.tv> (Daniel Haid's
	message of "Tue, 24 May 2011 00:45:47 +0100")
Message-ID: <m2wrhf4sw5.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Haid <d.haid@gogi.tv> writes:
>
> Unfortunately I am getting crashes with "iommu=allowed". I will look
> at git blame.

I added it originally. The VIA chipset seems to hang on most
DMAs through the IOMMU, so it was disabled.

-Andi

