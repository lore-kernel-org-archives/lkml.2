Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab0HQHtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 03:49:18 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52680 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab0HQHtR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 03:49:17 -0400
MIME-Version: 1.0
In-Reply-To: <4C6A3E2D.3050601@monstr.eu>
References: <20100817055754.20330.73078.stgit@angua> <4C6A3E2D.3050601@monstr.eu>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 17 Aug 2010 01:48:56 -0600
X-Google-Sender-Auth: Rhy8i4XLaZ5HMtZgnWIE0BFm-NQ
Message-ID: <AANLkTi=o+9mQeFWCvxkQNCZxvvfpkeXT9gEzvxZHhq_5@mail.gmail.com>
Subject: Re: [PATCH] of: Fix missing includes
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 1:45 AM, Michal Simek <monstr@monstr.eu> wrote:
> Grant Likely wrote:
>>
>> This patch fixes missing includes from a number of .c files because
>> the code (wrongfully) depended on prom.h including them.  The include
>> of linux/of_address.h was removed in microblaze prom.h in commit
>> "of/address: Clean up function declarations" (sha1 id 22ae782f8), but
>> not fixed in some users.  This patch fixes them up.
>>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>> ---
>>
>> Hi Michal, here's my patch that fixes the microblaze include issues.  I've
>> got it in my merge-devicetree branch which I'll be asking Linus to pull on
>> tommorrow after it has been through cross-arch build testing (unless I
>> hear
>> otherwise from you).
>
> Tested-by: Michal Simek <monstr@monstr.eu>

Thanks.

> Miohal

Who is Miohal, and why is he at your keyboard?  :-D

g.
