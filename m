Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab1IPBP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 21:15:56 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:50070 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750868Ab1IPBPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 21:15:55 -0400
Message-ID: <4E72A2A1.1020400@marvell.com>
Date: Fri, 16 Sep 2011 09:13:05 +0800
From: Leo Yan <leoy@marvell.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <hzhuang1@marvell.com>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 2/2] ARM: mmp: add audio sram allocator
References: <1312167547-26740-1-git-send-email-leoy@marvell.com> <1312167547-26740-3-git-send-email-leoy@marvell.com> <20110915143857.GL28104@game.jcrosoft.org>
In-Reply-To: <20110915143857.GL28104@game.jcrosoft.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Sep 2011 01:10:50.0617 (UTC) FILETIME=[7958EE90:01CC740D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/15/2011 10:38 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 10:59 Mon 01 Aug     , Leo Yan wrote:
>> Implement the audio sram allocator with genalloc,
>> so that can dynamically allocate the buffer
>> to pcm devices as need.
>>
>> Signed-off-by: Leo Yan<leoy@marvell.com>
> this can be more generic nad move to lib/genalloc.c

This is an older version, i have updated the patch same as you said.
pls see below link for the latest patch:
http://lists.arm.linux.org.uk/lurker/message/20110815.030920.2ad4227b.en.html

Thx,
Leo Yan
