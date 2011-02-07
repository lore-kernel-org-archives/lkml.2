Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab1BGSib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 13:38:31 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58145 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab1BGSia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 13:38:30 -0500
Message-ID: <4D503C22.40509@monstr.eu>
Date: Mon, 07 Feb 2011 19:38:26 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: microblaze: Convert irq chip to new functions
References: <1297102176-20768-1-git-send-email-monstr@monstr.eu> <alpine.LFD.2.00.1102071935440.31804@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1102071935440.31804@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Mon, 7 Feb 2011, Michal Simek wrote:
> 
>> Hi Thomas,
>>
>> I have tested them and there are several problems which I've fixed.
>> I have added that changes to your patch 2/3. I am sending them as v2.
>>
>> For all others patches:
>> Tested-by: Michal Simek <monstr@monstr.eu>
>>
>> They can go through your tree because you have all patches around irq.
> 
> They are not core code specific, so you can send them to linus in the
> .39 merge window.

Ok. I will take care about.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
