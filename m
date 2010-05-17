Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab0EQIlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 04:41:53 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44271 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab0EQIlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 04:41:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4BF1011E.6010808@jp.fujitsu.com>
Date: Mon, 17 May 2010 17:41:02 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 2/2] Use HW_ERR in MCE handler
References: <1274083325.3564.654.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1274083325.3564.654.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/05/17 17:02), Huang Ying wrote:
> Use HW_ERR printk prefix in MCE handler. To make it more explicit that
> this is hardware error instead of software error.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---

I like this.
At least it is useful to gather/filter error log by "grep".

For both of this series:
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>


Thanks,
H.Seto

