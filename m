Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482Ab2DJVIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 17:08:30 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:46920 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab2DJVI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 17:08:29 -0400
MIME-Version: 1.0
In-Reply-To: <4F8462DE.4030004@ti.com>
References: <1333442836-9947-1-git-send-email-akinobu.mita@gmail.com>
	<1333442836-9947-3-git-send-email-akinobu.mita@gmail.com>
	<4F8462DE.4030004@ti.com>
Date: Wed, 11 Apr 2012 06:08:28 +0900
Message-ID: <CAC5umygW+i=8=a+x7BnDuN=GPBFSXA4TWgrvQQvtWv0jSreWXw@mail.gmail.com>
Subject: Re: [PATCH 3/4] arm: davinci: use for_each_set_bit_from
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Sekhar Nori <nsekhar@ti.com>,
        Christian Riesch <christian.riesch@omicron.at>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Kevin Hilman <khilman@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/11 Sekhar Nori <nsekhar@ti.com>:
> Hi Akinobu,
>
> On 4/3/2012 2:17 PM, Akinobu Mita wrote:
>> Use for_each_set_bit_from to iterate over all the set bit in a memory
>> region.
>>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> Cc: Sekhar Nori <nsekhar@ti.com>
>> Cc: Kevin Hilman <khilman@ti.com>
>> Cc: davinci-linux-open-source@linux.davincidsp.com
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: linux-arm-kernel@lists.infradead.org
>
> Looks good to me. If you are planning to send this upstream outside of
> davinci tree, please add my:
>
> Acked-by: Sekhar Nori <nsekhar@ti.com>
>
> Else, let me know and I will be happy to queue it.

Christian found a bug in this patch. So  I'll resend it, then please queue it
to your tree.
