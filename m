Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab1GQS5Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 14:57:16 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46688 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab1GQS5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 14:57:14 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6410"; a="104062263"
X-IronPort-AV: E=Sophos;i="4.67,218,1309762800"; 
   d="scan'208";a="90455664"
Message-ID: <4E23307B.4060504@qca.qualcomm.com>
Date: Sun, 17 Jul 2011 21:56:59 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <devel@linuxdriverproject.org>, <gregkh@suse.de>, <error27@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/3] ath6kl: neatening
References: <cover.1310927985.git.joe@perches.com>
In-Reply-To: <cover.1310927985.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.234.11.54]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2011 09:43 PM, Joe Perches wrote:
> Joe Perches (3):
>   ath6kl: Add missing newlines and coalesce messages
>   ath6kl: Remove __func__ uses from ath6kl_err
>   ath6kl: cfg80211: Add and use ath6kl_cfg80211_ready helper

Nice, thanks a lot. I'm planning to send v3 of athk6kl patches later
today. Is it okay for you if I amend your three patches to that patchset?

Kalle
