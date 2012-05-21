Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab2EUGRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 02:17:06 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11885 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab2EUGRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 02:17:04 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6717"; a="190684255"
X-IronPort-AV: E=Sophos;i="4.75,628,1330934400"; 
   d="scan'208";a="312204760"
Message-ID: <4FB9DDD9.8000506@qca.qualcomm.com>
Date: Mon, 21 May 2012 09:16:57 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Greg KH <greg@kroah.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: linux-next: manual merge of the usb tree with the net-next tree
References: <20120521161008.c0cc00b91642ed7a3875a686@canb.auug.org.au>
In-Reply-To: <20120521161008.c0cc00b91642ed7a3875a686@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2012 09:10 AM, Stephen Rothwell wrote:

> Today's linux-next merge of the usb tree got a conflict in
> drivers/net/wireless/ath/ath6kl/usb.c between commit 9cbee358687e
> ("ath6kl: add full USB support") from the net-next tree and commit
> e1f12eb6ba6f ("USB: Disable hub-initiated LPM for comms devices") from
> the usb tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Is there anything I should do in ath6kl to handle the issue?

Kalle
