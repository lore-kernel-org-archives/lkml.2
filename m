Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab2KIFpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 00:45:17 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:63263 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab2KIFpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 00:45:11 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-c3-509c9865b54e
Message-id: <509C985B.8060206@samsung.com>
Date: Fri, 09 Nov 2012 14:44:59 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011
 Thunderbird/16.0.1
MIME-version: 1.0
To: Chris Ball <cjb@laptop.org>
Cc: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>,
        Will Newton <will.newton@gmail.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dw_mmc: fix more const pointer warnings
References: <1350376988-27477-1-git-send-email-james.hogan@imgtec.com>
 <508E4DB6.20504@imgtec.com> <87a9v5xuqj.fsf@octavius.laptop.org>
 <201211081426.12208.arnd@arndb.de> <87zk2s5fj6.fsf@octavius.laptop.org>
In-reply-to: <87zk2s5fj6.fsf@octavius.laptop.org>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t8zTd3UGXMCDFqfMVtc3jWHzeLI/35G
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDK2/HrCXLCTtWLD7ouMDYzLWLoYOTkkBEwkDnS/grLF
	JC7cW88GYgsJLGOUeNqkCVPzZ/px1i5GLqD4dEaJezNvM0I4LxklDq2aC9bNK6Al8efPNnYQ
	m0VAVeJ+53ywSWwCOhLbvx1n6mLk4BAVCJPYuTkdolxQ4sfke2CtIgLyEvf7voGVMwssZ5J4
	uaQQxBYWsJHY2/qcHWLXZUaJXQcesYDM4RQwlNjV7AhiMgvoSdy/qAXRKi+xec1bZogLBCS+
	TT4EVi0hICux6QAzyBQJgW52ic4/Hxgh/pKUOLjiBssERrFZSC6ahTB1FpKpCxiZVzGKphYk
	FxQnpeca6hUn5haX5qXrJefnbmKExIXUDsaVDRaHGAU4GJV4eBMfzA4QYk0sK67MPcQowcGs
	JMI7N3NOgBBvSmJlVWpRfnxRaU5q8SFGH6BjJzJLiSbnA2M2ryTe0NjA2NDQ0tDM1NLUAIew
	kjhvs0dKgJBAemJJanZqakFqEcw4Jg5OqQbGmPyFXk7F/6ee3HIicJayxI7JLDwWz+dPYpkt
	k8T9qVJsT8kJ1Qu9R2POTHYusfjbObOeW0fm89U5U7JfpWq907coXdh3TnZCguSs9bPl/q+q
	5/ovlSbM9DDyppSpXfPB3a5umtzeBeXLJ+QpbLM1YGVYal2z1X/fjieqWVyNzzc/bOvcsLBH
	iaU4I9FQi7moOBEABt3SXLgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t9jQd2UGXMCDC7vtLS4vGsOm8WR//2M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmbPn1hLlgJ2vF
	ht0XGRsYl7F0MXJySAiYSPyZfpwVwhaTuHBvPVsXIxeHkMB0Rol7M28zQjgvGSUOrZoL1sEr
	oCXx5882dhCbRUBV4n7nfDYQm01AR2L7t+NMXYwcHKICYRI7N6dDlAtK/Jh8D6xVREBe4n7f
	N7ByZoHlTBIvlxSC2MICNhJ7W5+zQ+y6zCix68AjFpA5nAKGEruaHUFMZgE9ifsXtSBa5SU2
	r3nLPIFRYBaSDbMQqmYhqVrAyLyKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzjunkntYFzZ
	YHGIUYCDUYmHN/HB7AAh1sSy4srcQ4wSHMxKIrxzM+cECPGmJFZWpRblxxeV5qQWH2L0AXp/
	IrOUaHI+MCXklcQbGpuYGVkamRmbmBsb4xBWEudt9kgJEBJITyxJzU5NLUgtghnHxMEp1cCY
	8enQkicMuxgFTcwuJ9WGv3JhrYxn04sXnNice2b2hT39TVxrXJ/2yea3M0c+F3mr2+zBvC+6
	z+iw81EFj8dVnhUPm9eKle6p+LXPLltEcLFwmmJg/HFGB1PFJb9PCrl+P7W9Wui3icb1ZutJ
	eVLenQJb1t/4ZRGwT/myRsHfdoEeuc3S+5RYijMSDbWYi4oTAZhClEDoAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Great..Thanks Arnd and Chris.

Best Regards,
Jaehoon Chung
On 11/08/2012 11:35 PM, Chris Ball wrote:
> Hi Arnd,
> 
> On Thu, Nov 08 2012, Arnd Bergmann wrote:
>> The patch "dw_mmc: fix multiple drv_data NULL dereferences" has
>> unfortunately clashed with my "mmc: dw_mmc: constify
>> dw_mci_idmac_ops in exynos back-end" patch, causing new warnings
>> to appear.
>>
>> This should hopefully fix the issue for good.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> Thanks, pushed to mmc-next for 3.7.
> 
> (Jaehoon also sent a patch to fix these last night, but yours applies to
> current mmc-next and his doesn't, so I'll take this one instead.)
> 
> - Chris.
> 

