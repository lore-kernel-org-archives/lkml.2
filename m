Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab1GEGTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 02:19:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33325 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753580Ab1GEGTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 02:19:07 -0400
Date: Mon, 4 Jul 2011 23:19:03 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@gmail.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Donggeun Kim <dg77.kim@samsung.com>
Subject: Re: [PATCH 3/3] MFD: MAX8997: IRQ definition moved to public header.
Message-ID: <20110705061903.GD1625@opensource.wolfsonmicro.com>
References: <1309397507-24959-1-git-send-email-myungjoo.ham@samsung.com>
 <1309397507-24959-3-git-send-email-myungjoo.ham@samsung.com>
 <20110630052808.GA796@opensource.wolfsonmicro.com>
 <BANLkTikGR-HdVZ-5h3kW64wiFduuuiU6Vw@mail.gmail.com>
 <20110630055719.GA930@opensource.wolfsonmicro.com>
 <BANLkTin4sCfX1Ahb_Td6VWH28s7SukYN-g@mail.gmail.com>
 <20110630155634.GE3249@opensource.wolfsonmicro.com>
 <BANLkTikPOj6N=TQ=tayx7hTXcLAJd5zf7w@mail.gmail.com>
 <20110704171634.GD28726@opensource.wolfsonmicro.com>
 <CAJ0PZbST6Xp82HTxpspiSEbjPmSzUuiKaHsycUKfyBFPQsSA_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ0PZbST6Xp82HTxpspiSEbjPmSzUuiKaHsycUKfyBFPQsSA_Q@mail.gmail.com>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 02:57:54PM +0900, MyungJoo Ham wrote:
> On Tue, Jul 5, 2011 at 2:16 AM, Mark Brown

> > My understanding was that one of the goals of the power_supply subsystem
> > was to support this sort of interaction? This (and your subsequent
> > paragraphs) all sounds entirely sensible but it should be being dealt
> > with at a higher level with the various charger drivers delivering
> > events into a subsystem or board driver which coordinates them all.  It
> > seems like the driver should be doing the work of dealing with the
> > actual interrupts.

> Yes, I also think that it is supposed to read and update attributes of
> chargers. However, I don't see any ways to interconnect chargers and
> related devices with power_supply subsystem.

Nor do I, but this is just software so we should be able to make it do
what's needed here.

> If we let a user process interconnect the chargers and related
> devices, we need to allow userland to access (both read and write)

I didn't say anything about userspace, and I wouldn't expect userspace
to do anything except policy here.
