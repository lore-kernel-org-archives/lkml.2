Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab1F1BDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 21:03:21 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:2877 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755448Ab1F1BCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 21:02:15 -0400
Message-ID: <4E092814.1080701@dsn.okisemi.com>
Date: Tue, 28 Jun 2011 10:02:12 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Alexander Stein <alexander.stein@systec-electronic.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "toshiharu-linux@dsn.okisemi.com" <toshiharu-linux@dsn.okisemi.com>
Subject: Re: [PATCH] pch_gpio: transform mutex into spinlock
References: <1308665847-13924-1-git-send-email-alexander.stein@systec-electronic.com> <20110627224722.GG20865@ponder.secretlab.ca>
In-Reply-To: <20110627224722.GG20865@ponder.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/28 7:47), Grant Likely wrote:
> On Tue, Jun 21, 2011 at 04:17:27PM +0200, Alexander Stein wrote:
>> gpio_chip.can_sleep is 0, but gpio_set_value&  friends lock a mutex. Thus
>> those functions are not callable from interrupt context.
>> Changing mutex into spinlock.
>>
>> Signed-off-by: Alexander Stein<alexander.stein@systec-electronic.com>
>
> Tomoya, what do you think of this patch?
>

Seeing some upstreamed GPIO driver, Alexander's comment looks right.

Best Regards,

tomoya
OKI SEMICONDUCTOR CO., LTD.
