Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab1KIOGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 09:06:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56237 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752570Ab1KIOGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 09:06:50 -0500
Date: Wed, 9 Nov 2011 14:06:47 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: ashish.jangam@kpitcummins.com, linaro-dev@lists.linaro.org,
        lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
        Dajun <dajun.chen@diasemi.com>
Subject: Re: [Patch 5/11] Regulator: DA9052/53 regulator support v5
Message-ID: <20111109140647.GA587@opensource.wolfsonmicro.com>
References: <1318950455.4644.65.camel@L-0761.kpit.com>
 <1320740905.5640.3.camel@L-0761.kpit.com>
 <4EBA7544.5030403@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBA7544.5030403@linaro.org>
X-Cookie: Avoid reality at all costs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 08:42:44PM +0800, Ying-Chun Liu (PaulLiu) wrote:

> Hi Mark,

> I've already tested this driver (v5) with the DA9052 MFD v8 driver
> posted on 20111103. It is tested on my imx53 Quickstart board. This
> patch also looks good to me. Please review this driver if possible.

Please resubmit if you want it reviewed, to reiterate the problems with
the core driver meant I didn't see much value in reviewing the code.  I
can't review the code if I don't have a copy.  I'm also note sure why
you're asking me alone to review the code?

If Linaro wants to help get this stuff upstream I strongly suggest you
help the guys with the process issues that have been (for example we've
still not seen an actual patch series submitted).  Possibly taking over
the actual patch submissions would be helpful.
