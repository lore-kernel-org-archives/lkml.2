Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab2ENXZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 19:25:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:18205 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758274Ab2ENXZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 19:25:32 -0400
X-AuditID: cbfee61b-b7b94ae000002e44-82-4fb19468457b
Message-id: <4FB19468.10807@samsung.com>
Date: Tue, 15 May 2012 08:25:28 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: broonie@opensource.wolfsonmicro.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, jonghwa3.lee@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] MAX77693: add initial MAX77693 MFD driver
References: <1336995592-1505-1-git-send-email-cw00.choi@samsung.com>
 <20120514205538.GG12740@sortiz-mobl>
In-reply-to: <20120514205538.GG12740@sortiz-mobl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On 05/15/2012 05:55 AM, Samuel Ortiz wrote:

> Hi Chanwoo,
> 
> On Mon, May 14, 2012 at 08:39:52PM +0900, Chanwoo Choi wrote:
>> MAX77693 is sub PMIC(Power Management IC) working
>> with other main PMIC. It has several features:
>> -PMIC
>> -MUIC(Micro USB Interface Controller)
>> -Camera flash LED control
>> -Haptic motor control
>>
>> This patch adds initial basis for several devices.
>> It is tested on TRATS board.
> Applied both patches, thanks. And thanks to Mark for the quick review.
> 

Thank you for your reply and applied it.

Best Regards,
Chanwoo Choi
