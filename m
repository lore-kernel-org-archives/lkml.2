Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab2ADSu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 13:50:59 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26114 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab2ADSu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 13:50:56 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6579"; a="152200667"
X-IronPort-AV: E=Sophos;i="4.71,456,1320652800"; 
   d="scan'208";a="156920430"
Message-ID: <4F049F6B.3030900@qca.qualcomm.com>
Date: Wed, 4 Jan 2012 20:50:19 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <sfr@canb.auug.org.au>, <netdev@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linville@tuxdriver.com>
Subject: Re: linux-next: merge of the wireless-next tree into the net-next
 tree
References: <20120104105947.8bac77d1d7198a49e6feeca8@canb.auug.org.au>	<4F040799.7080604@qca.qualcomm.com> <20120104.132412.1376413566875687968.davem@davemloft.net>
In-Reply-To: <20120104.132412.1376413566875687968.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2012 08:24 PM, David Miller wrote:
> From: Kalle Valo <kvalo@qca.qualcomm.com>
> Date: Wed, 4 Jan 2012 10:02:33 +0200
> 
>> For a temporary solution I'll send a patch which forces ath6kl to
>> build only as a module and I'll send ath6kl_core.ko patches ASAP
>> after that.
> 
> That's not reasonable, fix it properly.

I will, I have the patches almost ready now. Will send them tonight.
Just wanted to send a quick fix first.

Sorry about the whole mess. I was sure that I compile tested the usb
code properly when I added them, but apparently I didn't.

Kalle
