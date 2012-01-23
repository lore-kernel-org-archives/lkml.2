Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab2AWTdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 14:33:04 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59468 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753647Ab2AWTdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 14:33:02 -0500
Date: Mon, 23 Jan 2012 19:33:00 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Karol Lewandowski <lmctlx@gmail.com>
Cc: Karol Lewandowski <k.lewandowsk@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        linux-kernel@vger.kernel.org, rpurdie@rpsys.net,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        kgene.kim@samsung.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, dg77.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Rajendra Nayak <rnayak@ti.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v2 2/2] regulator: add device tree support for max8997
Message-ID: <20120123193259.GC26409@opensource.wolfsonmicro.com>
References: <1326353738-26864-1-git-send-email-thomas.abraham@linaro.org>
 <1326353738-26864-3-git-send-email-thomas.abraham@linaro.org>
 <4F1D9DDE.2070106@samsung.com>
 <20120123182056.GA26409@opensource.wolfsonmicro.com>
 <4F1DB34C.4030103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F1DB34C.4030103@gmail.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 08:21:48PM +0100, Karol Lewandowski wrote:
> On 01/23/2012 07:20 PM, Mark Brown wrote:

> >Documentation/SubmittingPatches please...

> I should have stated explicitly that purpose of this patch (I should
> have called it sniplet) was to show my point only.

> IMHO it's still up to debate how above problem should be solved.

It looks like a reasonable solution to me, and it wouldn't conflict with
any better solution that does come along.

> I'm not entirely sure that we really need things like e.g. "EN32KHz
> AP" in DT (nor in platform data, for that matter).  I would like to
> see Thomas' opinion first.

The 32kHz crystals are a bit of an odd case, really those should be
handled by the clock API but obviously that's stalled and has been for
quite some time.
