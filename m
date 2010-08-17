Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab0HQHw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 03:52:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38018 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab0HQHwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 03:52:24 -0400
Message-ID: <4C6A3FB5.5060804@monstr.eu>
Date: Tue, 17 Aug 2010 09:52:21 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of: Fix missing includes
References: <20100817055754.20330.73078.stgit@angua> <4C6A3E2D.3050601@monstr.eu> <AANLkTi=o+9mQeFWCvxkQNCZxvvfpkeXT9gEzvxZHhq_5@mail.gmail.com>
In-Reply-To: <AANLkTi=o+9mQeFWCvxkQNCZxvvfpkeXT9gEzvxZHhq_5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
> On Tue, Aug 17, 2010 at 1:45 AM, Michal Simek <monstr@monstr.eu> wrote:
>> Grant Likely wrote:
>>> This patch fixes missing includes from a number of .c files because
>>> the code (wrongfully) depended on prom.h including them.  The include
>>> of linux/of_address.h was removed in microblaze prom.h in commit
>>> "of/address: Clean up function declarations" (sha1 id 22ae782f8), but
>>> not fixed in some users.  This patch fixes them up.
>>>
>>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>>> ---
>>>
>>> Hi Michal, here's my patch that fixes the microblaze include issues.  I've
>>> got it in my merge-devicetree branch which I'll be asking Linus to pull on
>>> tommorrow after it has been through cross-arch build testing (unless I
>>> hear
>>> otherwise from you).
>> Tested-by: Michal Simek <monstr@monstr.eu>
> 
> Thanks.
> 
>> Miohal
> 
> Who is Miohal, and why is he at your keyboard?  :-D

I tried to use my new nickname but it seems you don't like it that's why 
I will use only my given name. :-)

Cheers,
Michal



-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
