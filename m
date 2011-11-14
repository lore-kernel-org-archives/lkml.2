Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab1KNSRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 13:17:14 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50815 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab1KNSRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 13:17:13 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6530"; a="137515669"
Message-ID: <4EC15B29.7020909@codeaurora.org>
Date: Mon, 14 Nov 2011 10:17:13 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Sebastien Jan <s-jan@ti.com>,
        Ben Dooks <ben@simtec.co.uk>
Subject: Re: [PATCH 0/5] ks8851 MAC and eeprom updates
References: <1319681870-11972-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1319681870-11972-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/11 19:17, Stephen Boyd wrote:
> I pulled this patch series off the netdev list[1] when the eeprom
> reading didn't work for my ks8851 and I wanted the mac address to be
> read out at boot. It all seems to work well, so I'm posting it here
> again, slightly cleaned up and simplified, for inclusion.
[snip]
>
>  drivers/misc/eeprom/eeprom_93cx6.c   |   88 ++++++
>  drivers/net/ethernet/micrel/Kconfig  |    2 +
>  drivers/net/ethernet/micrel/ks8851.c |  513 ++++++++++++----------------------
>  drivers/net/ethernet/micrel/ks8851.h |   15 +-
>  include/linux/eeprom_93cx6.h         |    8 +
>  5 files changed, 278 insertions(+), 348 deletions(-)

Any comments on this series?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

