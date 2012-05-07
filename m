Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab2EGBLu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 21:11:50 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:49022 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053Ab2EGBLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 21:11:49 -0400
X-AuditID: cbfee61b-b7c60ae000000c58-fa-4fa721537e27
Message-id: <4FA72155.8020301@samsung.com>
Date: Mon, 07 May 2012 10:11:49 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RESEND PATCH v2 0/2] power_supply: update Charger-Manager
References: <4F7E3945.6000800@samsung.com> <4F9684BC.2000004@samsung.com>
 <20120506025623.GA8437@lizard>
In-reply-to: <20120506025623.GA8437@lizard>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

Firstly, thank for your reply and applied.

On 05/06/2012 11:56 AM, Anton Vorontsov wrote:
> On Tue, Apr 24, 2012 at 07:47:24PM +0900, Chanwoo Choi wrote:
> [...]
>>  Documentation/power/charger-manager.txt |   41 +++-
>>  drivers/power/charger-manager.c         |  391
>> +++++++++++++++++++++++++++++++
>>  include/linux/power/charger-manager.h   |   49 ++++-
>>  3 files changed, 471 insertions(+), 10 deletions(-)
> 
> Applied, thanks!
> 
> Note that the patches were word-wrap damaged, I had to fix them by
> hand. The file 'linux/Documentation/email-clients.txt' contains some
> useful tips for setting up commonly used mail clients. You might
> also try using 'git send-email'.

I'm so sorry. I will not do a same mistake.

> 
> While looking through the CM code, I noticed that cm uevents
> are not friendly wrt several chargers (the code has static variables
> in the uevent_notify() func).
> 
I will modify obscure code about your comment in the next patch.

> Also, what's the rationale behind implementing own uevent handling,
> and not using power_supply uevents (see power_supply_sysfs.c
> and power_supply_changed() thing)? Also, you don't seem to
> report variables in the uevent, but just messages. That's unusual.
> 
OK, I will implement uevent feature in charger-manager by using
power_supply uevents
instead of own uevent handling and post new patchset.

Best Regards,
Chanwoo Choi

