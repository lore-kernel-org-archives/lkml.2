Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab2JZKQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 06:16:14 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52769 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324Ab2JZKQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 06:16:13 -0400
Message-ID: <508A62CC.8070701@ti.com>
Date: Fri, 26 Oct 2012 15:45:40 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: <khilman@ti.com>, <linux@arm.linux.org.uk>,
        <yongjun_wei@trendmicro.com.cn>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: davinci: dm644x: move the dereference below the
 NULL test
References: <CAPgLHd81OwYR65x56Fe1+hcWQsK1wiA6+MQYLBwvP59o-kH8QA@mail.gmail.com>
In-Reply-To: <CAPgLHd81OwYR65x56Fe1+hcWQsK1wiA6+MQYLBwvP59o-kH8QA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/10/2012 10:19 AM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> The dereference should be moved below the NULL test.
> 
> spatch with a semantic match is used to found this.
> (http://coccinelle.lip6.fr/)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Queuing this for inclusion in v3.8

Thanks,
Sekhar
