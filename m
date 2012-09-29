Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030596Ab2I2Cyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 22:54:37 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:44616 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839Ab2I2Cyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 22:54:35 -0400
Message-ID: <506662DD.4030309@oracle.com>
Date: Sat, 29 Sep 2012 10:54:21 +0800
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        levinsasha928@gmail.com, Feng Jin <joe.jin@oracle.com>,
        dan.carpenter@oracle.com
Subject: Re: [PATCH -v2] mm: frontswap: fix a wrong if condition in frontswap_shrink
References: <505C27FE.5080205@oracle.com>  <1348745730.1512.19.camel@x61.thuisdomein> <50651CF5.5030903@oracle.com> <1348844071.1553.14.camel@x61.thuisdomein>
In-Reply-To: <1348844071.1553.14.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2012-09-28 22:54, Paul Bolle wrote:
> On Fri, 2012-09-28 at 11:43 +0800, Zhenzhong Duan wrote:
>> On 2012-09-27 19:35, Paul Bolle wrote:
>>> I think setting pages_to_unuse to zero here is not needed. It is
>>> initiated to zero in frontswap_shrink() and hasn't been touched since.
>>> See my patch at https://lkml.org/lkml/2012/9/27/250.
>> Yes, it's unneeded. But I didn't see warning as you said in above link
>> when run 'make V=1 mm/frontswap.o'.
> Not even before applying your patch? Anyhow, after applying your patch
> the warnings gone here too.
I tested both cases, no warning, also didn't see -Wmaybe-uninitialized 
when make.
My env is el5. gcc version 4.1.2 20080704 (Red Hat 4.1.2-52)
Maybe your gcc built in/implicit spec use that option?
thanks
zduan
