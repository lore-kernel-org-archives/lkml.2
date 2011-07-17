Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab1GQVtx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 17:49:53 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39226 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab1GQVtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 17:49:51 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6410"; a="104072136"
X-IronPort-AV: E=Sophos;i="4.67,218,1309762800"; 
   d="scan'208";a="155115134"
Message-ID: <4E2358F7.3020709@qca.qualcomm.com>
Date: Mon, 18 Jul 2011 00:49:43 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <devel@linuxdriverproject.org>, <gregkh@suse.de>, <error27@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/2] ath6kl: more neatening
References: <4E2349D4.4000204@qca.qualcomm.com> <cover.1310938421.git.joe@perches.com>
In-Reply-To: <cover.1310938421.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.234.11.54]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2011 12:38 AM, Joe Perches wrote:
>> Great, thanks. I have now applied your patches to ath6kl-cleanup tree
>> and they will be included in patchset v3.
> 
> Here's a couple of more.
> 
> Joe Perches (2):
>   ath6kl: Remove __func__ uses from ath6kl_dbg
>   ath6kl: Remove trailing unpaired close paren from ath6kl_err uses

Thanks again.

I just sent v3. But if I need to create v4 (I hope not) I'll include
your patches. If v3 is ok, I can resend your patches to wireless-testing
so that you don't need to followup.

Kalle
