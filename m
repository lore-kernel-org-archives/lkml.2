Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab2KQMKY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 07:10:24 -0500
Received: from 8bytes.org ([85.214.48.195]:55038 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676Ab2KQMKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 07:10:23 -0500
Date: Sat, 17 Nov 2012 13:10:21 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Omar Ramirez Luna <omar.luna@linaro.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 0/6] Move rest of omap-iommu to live in drivers/iommu
Message-ID: <20121117121021.GS25742@8bytes.org>
References: <20121102192221.4253.34303.stgit@muffinssi.local>
 <CAK=WgbYR8UMyDjySJLRC0tEbJO3FaFgjWxceNwMyVdMgEgwPig@mail.gmail.com>
 <CALLhW=5WNg8X0nX8U+AExocyNKW=wJ7oS36xg4ENMnfyJkX8RQ@mail.gmail.com>
 <20121112220033.GO6801@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121112220033.GO6801@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sat Nov 17 13:10:22 2012
X-DSPAM-Confidence: 0.9989
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50a77eae22971985220442
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 02:00:34PM -0800, Tony Lindgren wrote:
> Assuming Joerg is OK with these changes, I can push them into
> an immutable branch that Joerg can merge in as needed.
> 
> Further patches on top of this series can then be queued by
> Joerg as arch/arm/*omap* and me are then out of the way of
> iommu development.

Okay, from my side:

Acked-by: Joerg Roedel <joro@8bytes.org>

Please let me know which branch I need to pull into my tree when you
merged these patches.


	Joerg


