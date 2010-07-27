Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab0G0HfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 03:35:13 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58475 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab0G0HfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 03:35:11 -0400
Date: Tue, 27 Jul 2010 09:35:08 +0200
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: GCOV doesn't seem to work on ARM with kernel 2.6.35-rc6
In-reply-to: <4C4DBE8E.70102@linux.vnet.ibm.com>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <4C4E8C2C.3000903@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10)
 Gecko/20100620 Icedove/3.0.5
References: <4C4D6458.6040402@samsung.com> <4C4D6554.30707@samsung.com>
 <4C4DBE8E.70102@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2010 06:57 PM, Peter Oberparleiter wrote:
> Karol Lewandowski wrote:
>> On 07/26/2010 12:32 PM, Karol Lewandowski wrote:
>>> I'm trying to use code coverage measurements with mainline Linux kernel
>>> 2.6.35-rc6 on ARM platform (specifically on Samsung's S5PC110 board).
...
> I just tested gcov support for 2.6.35-rc6 on s390 and it works without
> a problem. My assumption would be that you are using an EABI-GCC to
> compile your kernel. Those compilers name their constructor symbols

Exactly.

> differently than the vanilla GCC so that the whole constructor calling
> mechanism on which the gcov support relies, will fail. If that is
> indeed the case, the following testing patch should solve your
> problem:

Yes, that was the case and your patch indeed solved my problem.

Thank you very much for your help!
