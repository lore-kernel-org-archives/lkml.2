Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933600Ab2ERIhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 04:37:24 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43437 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933136Ab2ERIhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 04:37:21 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-33-4fb60a3f44ff
Message-ID: <4FB60A70.6050707@kernel.org>
Date: Fri, 18 May 2012 17:38:08 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        Chen Liqin <liqin.chen@sunplusct.com>
Subject: Re: [PATCH v2 1/3] zsmalloc: support zsmalloc to ARM, MIPS, SUPERH
References: <1337133919-4182-1-git-send-email-minchan@kernel.org>   <1337153329.1751.5.camel@ubuntu.ubuntu-domain>   <4FB44147.5070704@kernel.org>  <1337216199.1837.11.camel@ubuntu.ubuntu-domain>  <4FB4B109.9000703@kernel.org> <1337305553.1844.3.camel@ubuntu.ubuntu-domain>
In-Reply-To: <1337305553.1844.3.camel@ubuntu.ubuntu-domain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guan,

On 05/18/2012 10:45 AM, Guan Xuetao wrote:

> On Thu, 2012-05-17 at 17:04 +0900, Minchan Kim wrote:
> 
>> ...
>> I don't think so.
>> It's terrible experience if all users have to look up local_flush_tlb_kernel_range of arch for using zsmalloc.
>>
>> BTW, does unicore32 support that function?
>> If so, I would like to add unicore32 in Kconfig.
>>
> Yes. Thanks.
> 
> Could you give me some materials on performance and testsuite?


Unfortunately, I don't have them. Nitin, Could you help Guan?

-- 
Kind regards,
Minchan Kim
