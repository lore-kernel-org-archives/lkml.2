Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab0JZLXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 07:23:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58040 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384Ab0JZLXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 07:23:37 -0400
Subject: Re: [PATCH 2/2 v2] regulator: max8952 - fix max8952_set_voltage
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Axel Lin <axel.lin@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
In-Reply-To: <AANLkTikm5Vsu5kdrS-70LEdoDE1OqzkTo6C=nyPC=oXe@mail.gmail.com>
References: <1288050954.2323.3.camel@phoenix>
	 <20101026011955.GA3432@opensource.wolfsonmicro.com>
	 <AANLkTikm5Vsu5kdrS-70LEdoDE1OqzkTo6C=nyPC=oXe@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 12:23:32 +0100
Message-ID: <1288092212.6906.0.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-26 at 10:38 +0900, Kyungmin Park wrote:
> Hi Axel,
> 
> Thank you for your works.
> 
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> On Tue, Oct 26, 2010 at 10:19 AM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
> > On Tue, Oct 26, 2010 at 07:55:54AM +0800, Axel Lin wrote:
> >> In current implementation, vid is declared as u8,
> >> then "vid == -1" is always false, and "vid >= 0" is always true.
> >> Thus change it to s8.
> >>
> >> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> >
> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > --

Both applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

