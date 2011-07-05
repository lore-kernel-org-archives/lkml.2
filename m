Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab1GETxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 15:53:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53991 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752494Ab1GETxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 15:53:49 -0400
Date: Tue, 5 Jul 2011 12:53:45 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@gmail.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Donggeun Kim <dg77.kim@samsung.com>
Subject: Re: [PATCH 3/3] MFD: MAX8997: IRQ definition moved to public header.
Message-ID: <20110705195344.GC8642@opensource.wolfsonmicro.com>
References: <20110630052808.GA796@opensource.wolfsonmicro.com>
 <BANLkTikGR-HdVZ-5h3kW64wiFduuuiU6Vw@mail.gmail.com>
 <20110630055719.GA930@opensource.wolfsonmicro.com>
 <BANLkTin4sCfX1Ahb_Td6VWH28s7SukYN-g@mail.gmail.com>
 <20110630155634.GE3249@opensource.wolfsonmicro.com>
 <BANLkTikPOj6N=TQ=tayx7hTXcLAJd5zf7w@mail.gmail.com>
 <20110704171634.GD28726@opensource.wolfsonmicro.com>
 <CAJ0PZbST6Xp82HTxpspiSEbjPmSzUuiKaHsycUKfyBFPQsSA_Q@mail.gmail.com>
 <20110705061903.GD1625@opensource.wolfsonmicro.com>
 <CAJ0PZbSrB9Cc-2h0xGot6kYUGR-uu0f7GVq43c_fSEd5oTMEog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ0PZbSrB9Cc-2h0xGot6kYUGR-uu0f7GVq43c_fSEd5oTMEog@mail.gmail.com>
X-Cookie: You too can wear a nose mitten.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 03:49:39PM +0900, MyungJoo Ham wrote:

> Anyway, I've been trying to implement some virtual device driver or
> psuedo framework in kernel to interconnect charger related devices,
> "charger manager". This code mentioned is to support that "charger
> manager". It is sort of at a higher level of charger related devices,
> taking device names of them as a platform data. The platform data
> taking the IRQ numbers is the one for that "charger manager".

Right, so what I'm saying is that the interface between the two blocks
should be changed so that the manager code isn't talking directly to the
interrupt but is talking to something higher level.
