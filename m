Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab1JRHDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 03:03:42 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:13972 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751368Ab1JRHDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 03:03:41 -0400
Message-ID: <4E9D24C9.3000309@dsn.lapis-semi.com>
Date: Tue, 18 Oct 2011 16:03:37 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: gpio-ml-ioh: Support interrupt function
References: <20111017201058.GA13916@elgon.mountain> <4E9CC93B.4000800@dsn.lapis-semi.com> <alpine.DEB.2.00.1110172251590.4880@chino.kir.corp.google.com> <4E9D1ED8.3070106@dsn.lapis-semi.com> <alpine.DEB.2.00.1110172350500.8959@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1110172350500.8959@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/10/18 15:52), David Rientjes wrote:
> On Tue, 18 Oct 2011, Tomoya MORINAGA wrote:
>
>> Hi, David
>> Thank you for your information.
>> I will try to test with '-1'.
>>
>> After testing with '-1',
>> I will post the patch for this.
>>
>
> Please try with NUMA_NO_NODE, that's what the slab allocators use and will
> be the ones consuming this.  It's available in include/linux/numa.h.

OK, I'll use NUMA_NO_NODE instead '-1'.

thanks,
-- 
tomoya
ROHM Co., Ltd.
