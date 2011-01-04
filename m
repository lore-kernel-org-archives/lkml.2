Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328Ab1ADNqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 08:46:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47748 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751026Ab1ADNqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 08:46:07 -0500
Date: Tue, 4 Jan 2011 13:44:35 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH v4 2/3] regulator MAX8998/LP3974: Support DVS-GPIO.
Message-ID: <20110104134434.GC24774@opensource.wolfsonmicro.com>
References: <20101224113805.GI27832@sortiz-mobl>
 <1294118261-18906-3-git-send-email-myungjoo.ham@samsung.com>
 <20110104084904.5765cd9e@lmajewski.digital.local>
 <AANLkTi=dJ83par+U8YfbpC3HVjEkc9rfPU8pxSFN_mTb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=dJ83par+U8YfbpC3HVjEkc9rfPU8pxSFN_mTb@mail.gmail.com>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 05:16:56PM +0900, MyungJoo Ham wrote:
> On Tue, Jan 4, 2011 at 4:49 PM, Lukasz Majewski <l.majewski@samsung.com> wrote:

> > Is it desirable to define all four for BUCK1 and two for BUCK2 DVS
> > voltages in platform code?

> In case a system with 4 buck1 preset voltages and 2 buck2 preset
> voltages, it is desirable. :)

I suspect Lukasz's question is more why this would be useful; I can
imagine that the main reason would be performance and in any case I
don't see it hurting to have the option.
