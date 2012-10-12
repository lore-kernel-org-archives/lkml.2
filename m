Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934000Ab2JLMu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 08:50:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52134 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933959Ab2JLMuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 08:50:55 -0400
Message-ID: <50781207.8060701@ti.com>
Date: Fri, 12 Oct 2012 18:20:15 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: <khilman@ti.com>, <linux@arm.linux.org.uk>,
        <yongjun_wei@trendmicro.com.cn>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] davinci: fix return value check by using IS_ERR in tnetv107x_devices_init()
References: <CAPgLHd-xYzLwnptYpOV4HrdJyn3AZahx2VGVAVLHiEYvcj-APw@mail.gmail.com>
In-Reply-To: <CAPgLHd-xYzLwnptYpOV4HrdJyn3AZahx2VGVAVLHiEYvcj-APw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

On 9/21/2012 11:42 AM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> In case of error, the function clk_get() returns ERR_PTR() not
> NULL pointer. The NULL test in the error handling should be
> replaced with IS_ERR().
> 
> dpatch engine is used to auto generated this patch.
> (https://github.com/weiyj/dpatch)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Queuing this for v3.8. While committing, I added ARM: prefix to the
subject line as is the norm with all arch/arm/* patches.

Thanks,
Sekhar
