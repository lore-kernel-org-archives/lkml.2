Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab2JICov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 22:44:51 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:51437 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab2JICos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 22:44:48 -0400
MIME-Version: 1.0
In-Reply-To: <50738C7A.9060905@wwwdotorg.org>
References: <CAPgLHd95ofKiKWC9B67q9mgkjsc6_YJ5x92aY0xKPiohuUMk4Q@mail.gmail.com>
	<50738C7A.9060905@wwwdotorg.org>
Date: Tue, 9 Oct 2012 10:44:47 +0800
Message-ID: <CAPgLHd-msJkHz5KxsxVhr0u8ainXU0t53XHeiwSeW2ShJkRbwg@mail.gmail.com>
Subject: Re: [PATCH] clk: fix return value check in bcm2835_init_clocks()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: swarren@wwwdotorg.org
Cc: mturquette@ti.com, yongjun_wei@trendmicro.com.cn,
        linux-arm-kernel@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2012 10:31 AM, Stephen Warren wrote:
> On 10/07/2012 08:02 AM, Wei Yongjun wrote:
>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>
>> In case of error, the function clk_register_fixed_rate() returns
>> ERR_PTR() and never returns NULL. The NULL test in the return value
>> check should be replaced with IS_ERR().
>>
>> dpatch engine is used to auto generate this patch.
>> (https://github.com/weiyj/dpatch)
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>
>
> Mike, this driver was added through arm-soc; I assume it's simplest to
> take this fixup through there too for 3.7-rc*? If so, Wei, could you
> resend this patch with my ack to arm@kernel.org? Thanks.

Will do, thanks.


