Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935807Ab0GPHjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 03:39:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52024 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935713Ab0GPHjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 03:39:21 -0400
Message-ID: <4C400C23.5070102@cn.fujitsu.com>
Date: Fri, 16 Jul 2010 15:37:07 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, mingo@elte.hu,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: [PATCH v2] perf: close the opened directories.
References: <4C1C3F7C.4030607@cn.fujitsu.com> <1277360965.2096.881.camel@ymzhang.sh.intel.com> <4C230362.5080704@cn.fujitsu.com> <20100624135227.GA4784@ghostprotocols.net>
In-Reply-To: <20100624135227.GA4784@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> Em Thu, Jun 24, 2010 at 03:04:02PM +0800, Gui Jianfeng escreveu:
>> When I ran "perf kvm ... top", I encountered the following error output.
>>
>>   Error: perfcounter syscall returned with -1 (Too many open files)
>>
>>   Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?
>>
>> Looking into perf, I found perf opens too many direcotries at initialization
>> time, but forgets to close them. Here is the fix.
>>
>> Signef-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> 
> Thanks, will apply.

Hi Arnaldo,

Would you pick up this fix?

Thanks,
Gui

> 
> - Arnaldo
> 
> 
