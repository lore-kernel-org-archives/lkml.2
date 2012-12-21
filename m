Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab2LUUXo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 15:23:44 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58623 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab2LUUXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 15:23:42 -0500
X-IronPort-AV: E=Sophos;i="4.84,331,1355126400"; 
   d="scan'208";a="16040724"
Message-ID: <50D4C54D.8020700@codeaurora.org>
Date: Fri, 21 Dec 2012 12:23:41 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dmitry Voytik <dvv.kernel@gmail.com>
CC: mmarek@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nconf: add j, k and l keys for menu navigation
References: <1356117145-14158-1-git-send-email-dvv.kernel@gmail.com>
In-Reply-To: <1356117145-14158-1-git-send-email-dvv.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/12 11:12, Dmitry Voytik wrote:
> Add vi-style keys for menu navigation: press j/k for down/up navigation
> and l for entering to a submenu. Unfortantely h key is reserved for
> the items help.

Maybe you can just add j/k for up/down and then use enter and backspace
for right/left?

>
> Signed-off-by: Dmitry Voytik <dvv.kernel@gmail.com>

Tested-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

