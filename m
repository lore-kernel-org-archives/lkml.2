Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab1GQUp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 16:45:26 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6943 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab1GQUpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 16:45:18 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6410"; a="104068141"
X-IronPort-AV: E=Sophos;i="4.67,218,1309762800"; 
   d="scan'208";a="90469297"
Message-ID: <4E2349D4.4000204@qca.qualcomm.com>
Date: Sun, 17 Jul 2011 23:45:08 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <devel@linuxdriverproject.org>, <gregkh@suse.de>, <error27@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/3] ath6kl: neatening
References: <cover.1310927985.git.joe@perches.com>	 <4E23307B.4060504@qca.qualcomm.com> <1310932335.2286.8.camel@Joe-Laptop>
In-Reply-To: <1310932335.2286.8.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.234.11.54]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2011 10:52 PM, Joe Perches wrote:
> On Sun, 2011-07-17 at 21:56 +0300, Kalle Valo wrote:
>> On 07/17/2011 09:43 PM, Joe Perches wrote:
>>> Joe Perches (3):
>>>   ath6kl: Add missing newlines and coalesce messages
>>>   ath6kl: Remove __func__ uses from ath6kl_err
>>>   ath6kl: cfg80211: Add and use ath6kl_cfg80211_ready helper
>> Nice, thanks a lot. I'm planning to send v3 of athk6kl patches later
>> today. Is it okay for you if I amend your three patches to that patchset?
> 
> 'course.

Great, thanks. I have now applied your patches to ath6kl-cleanup tree
and they will be included in patchset v3.

Kalle
