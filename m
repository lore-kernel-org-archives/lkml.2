Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab2LLDHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 22:07:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53723 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753763Ab2LLDHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 22:07:49 -0500
Date: Wed, 12 Dec 2012 12:07:41 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Abhilash Kesavan <a.kesavan@samsung.com>, lrg@ti.com,
        linux-kernel@vger.kernel.org, olof@lixom.net,
        grant.likely@secretlab.ca, thomas.abraham@linaro.org,
        kgene.kim@samsung.com, sameo@linux.intel.com
Subject: Re: [RFC PATCH 3/3] dt: Document: Add optional MAX77686 operating
 mode bindings
Message-ID: <20121212030740.GA30719@opensource.wolfsonmicro.com>
References: <1355120784-31118-1-git-send-email-a.kesavan@samsung.com>
 <1355120784-31118-2-git-send-email-a.kesavan@samsung.com>
 <1355120784-31118-3-git-send-email-a.kesavan@samsung.com>
 <1355120784-31118-4-git-send-email-a.kesavan@samsung.com>
 <CAD=FV=Wte=n8=nheTPuSVMDgAuzmsQ09PFNafS3BOAXUAvO_vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=Wte=n8=nheTPuSVMDgAuzmsQ09PFNafS3BOAXUAvO_vg@mail.gmail.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 10:30:42AM -0800, Doug Anderson wrote:

> The max77686 appears to support NORMAL and IDLE mode for most LDOs, so
> the only reasonable values for these two would be 2 and 4.  It appears
> that it would also be nonsensical (impossible to map to a register
> value) to have REGULATOR_MODE_NORMAL for suspend and
> REGULATOR_MODE_IDLE for the normal running mode.

The concept of normal and idle modes is Linux-specific, it's not a
generic hardware property.  You'd want to have something like the
expected current drain, the regulator API does already have support for
mapping into an optimal mode already.
