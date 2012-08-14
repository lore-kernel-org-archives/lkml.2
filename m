Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab2HNOeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:34:15 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41719 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab2HNOeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:34:13 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6802"; a="225143417"
X-IronPort-AV: E=Sophos;i="4.77,766,1336374000"; 
   d="scan'208";a="312006136"
Message-ID: <502A61DC.6070902@qca.qualcomm.com>
Date: Tue, 14 Aug 2012 17:34:04 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Marina Makienko <makienko@ispras.ru>
CC: "John W. Linville" <linville@tuxdriver.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ldv-project@ispras.ru>,
        ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] net: Checking usb_register() return value
References: <1344931890-15763-1-git-send-email-makienko@ispras.ru>
In-Reply-To: <1344931890-15763-1-git-send-email-makienko@ispras.ru>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2012 11:11 AM, Marina Makienko wrote:
> ath6kl_usb_init() does not check usb_register() return value.
> As a result it may incorrectly report success of driver initialization.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Marina Makienko <makienko@ispras.ru>

Thanks, applied to ath6kl.git. But I changed the title to use "ath6kl:"
and made some cosmetic changes to the code.

Kalle
