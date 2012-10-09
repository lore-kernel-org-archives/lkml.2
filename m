Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab2JICbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 22:31:23 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50851 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab2JICbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 22:31:22 -0400
Message-ID: <50738C7A.9060905@wwwdotorg.org>
Date: Mon, 08 Oct 2012 20:31:22 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>, mturquette@ti.com
CC: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: fix return value check in bcm2835_init_clocks()
References: <CAPgLHd95ofKiKWC9B67q9mgkjsc6_YJ5x92aY0xKPiohuUMk4Q@mail.gmail.com>
In-Reply-To: <CAPgLHd95ofKiKWC9B67q9mgkjsc6_YJ5x92aY0xKPiohuUMk4Q@mail.gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2012 08:02 AM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> In case of error, the function clk_register_fixed_rate() returns
> ERR_PTR() and never returns NULL. The NULL test in the return value
> check should be replaced with IS_ERR().
> 
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)

Acked-by: Stephen Warren <swarren@wwwdotorg.org>

Mike, this driver was added through arm-soc; I assume it's simplest to
take this fixup through there too for 3.7-rc*? If so, Wei, could you
resend this patch with my ack to arm@kernel.org? Thanks.
