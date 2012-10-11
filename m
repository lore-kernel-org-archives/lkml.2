Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933867Ab2JKBhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:37:04 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:43848 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933397Ab2JKBg4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:36:56 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Wei Yongjun <weiyj.lk@gmail.com>, <swarren@wwwdotorg.org>
From: Mike Turquette <mturquette@ti.com>
In-Reply-To: <CAPgLHd-msJkHz5KxsxVhr0u8ainXU0t53XHeiwSeW2ShJkRbwg@mail.gmail.com>
Cc: <yongjun_wei@trendmicro.com.cn>, <linux-arm-kernel@lists.infradead.org>,
        <linux-rpi-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
References: <CAPgLHd95ofKiKWC9B67q9mgkjsc6_YJ5x92aY0xKPiohuUMk4Q@mail.gmail.com>
 <50738C7A.9060905@wwwdotorg.org>
 <CAPgLHd-msJkHz5KxsxVhr0u8ainXU0t53XHeiwSeW2ShJkRbwg@mail.gmail.com>
Message-ID: <20121011013631.11595.26416@nucleus>
User-Agent: alot/0.3.2+
Subject: Re: [PATCH] clk: fix return value check in bcm2835_init_clocks()
Date: Wed, 10 Oct 2012 18:36:31 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Wei Yongjun (2012-10-08 19:44:47)
> On 10/09/2012 10:31 AM, Stephen Warren wrote:
> > On 10/07/2012 08:02 AM, Wei Yongjun wrote:
> >> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> >>
> >> In case of error, the function clk_register_fixed_rate() returns
> >> ERR_PTR() and never returns NULL. The NULL test in the return value
> >> check should be replaced with IS_ERR().
> >>
> >> dpatch engine is used to auto generate this patch.
> >> (https://github.com/weiyj/dpatch)
> > Acked-by: Stephen Warren <swarren@wwwdotorg.org>
> >
> > Mike, this driver was added through arm-soc; I assume it's simplest to
> > take this fixup through there too for 3.7-rc*? If so, Wei, could you
> > resend this patch with my ack to arm@kernel.org? Thanks.
> 
> Will do, thanks.

Works for me.

Mike
