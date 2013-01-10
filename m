Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab3AJSi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 13:38:27 -0500
Received: from 8bytes.org ([85.214.48.195]:56260 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611Ab3AJSi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 13:38:26 -0500
Date: Thu, 10 Jan 2013 19:38:23 +0100
From: "'Joerg Roedel'" <joro@8bytes.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Cho KyongHo'" <pullip.cho@samsung.com>,
        "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>
Subject: Re: [PATCH v6 00/12] iommu/exynos: Fixes and Enhancements of System
 MMU driver with DT
Message-ID: <20130110183823.GH25591@8bytes.org>
References: <003301cde30b$c584c2d0$508e4870$%cho@samsung.com>
 <032401cde783$485ae1a0$d910a4e0$@samsung.com>
 <20130110171844.GA2650@8bytes.org>
 <026e01cdef5d$364fd150$a2ef73f0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <026e01cdef5d$364fd150$a2ef73f0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jan 10 19:38:25 2013
X-DSPAM-Confidence: 0.9988
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50ef0aa122979484720149
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 10:06:24AM -0800, Kukjin Kim wrote:
> You know, we have several options to avoid it. When you take this series in
> your tree, you can provide topic branch for me. Or this series should be
> separated for arch/arm/ and drivers/ for both trees, then only drivers/iommu
> changes should be picked up in your tree. I'm OK both, let me know which one
> you would prefer or other way.

I would like to take the final version of this patch-set (when you
provided your Acked-by) into the arm/exynos branch in my tree. You can
then pull in this branch to the Samsung tree and we can the conflicts
this way.


	Joerg


