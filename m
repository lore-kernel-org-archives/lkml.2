Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab1IMHRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 03:17:47 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31389 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab1IMHRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 03:17:45 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6467"; a="117902143"
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yangjie@qca.qualcomm.com>,
        "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>, <stable@kernel.org>,
        <netdev@vger.kernel.org>, <jouni@qca.qualcomm.com>,
        <vthiagar@qca.qualcomm.com>, <senthilb@qca.qualcomm.com>
X-IronPort-AV: E=Sophos;i="4.68,371,1312182000"; 
   d="scan'208";a="118584261"
Message-ID: <4E6F0390.4060704@qca.qualcomm.com>
Date: Tue, 13 Sep 2011 10:17:36 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
Subject: Re: [PATCH] MAINTANERS: update Qualcomm Atheros addresses
References: <1314137251-32096-1-git-send-email-lrodriguez@qca.qualcomm.com>
In-Reply-To: <1314137251-32096-1-git-send-email-lrodriguez@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.1.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 01:07 AM, Luis R. Rodriguez wrote:
> From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
> 
> Qualcomm ate up Atheros, all of the old e-mail addresses
> no longer work and e-mails sent to it will bounce. Update
> the addresses to the new shiny Qualcomm Atheros (QCA) ones.
> 
> Cc: stable@kernel.org
> Cc: netdev@vger.kernel.org
> Cc: jouni@qca.qualcomm.com
> Cc: yangjie@qca.qualcomm.com
> Cc: vthiagar@qca.qualcomm.com
> Cc: senthilb@qca.qualcomm.com
> Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
> ---
> 
> John, I've left out ath6kl as you removed that so I take it
> the respective MAINTAINERS entry was deleted as well (although
> I do not see this on wireless-testing.git)

Actually I forgot the MAINTAINERS file altogether, thanks for reminding.
Shortly I'll send a patch to linux-wireless which updates the ath6kl entry.

Kalle
