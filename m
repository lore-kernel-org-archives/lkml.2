Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab2FNEuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 00:50:22 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38366 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab2FNEuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 00:50:20 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6741"; a="200879908"
X-IronPort-AV: E=Sophos;i="4.75,768,1330934400"; 
   d="scan'208";a="266371693"
Message-ID: <4FD96D85.4010505@qca.qualcomm.com>
Date: Thu, 14 Jun 2012 10:20:13 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: linux-next: manual merge of the net-next tree with the wireless
 tree
References: <20120614131256.2fed671219b8d571a47987c2@canb.auug.org.au>
In-Reply-To: <20120614131256.2fed671219b8d571a47987c2@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thursday 14 June 2012 08:42 AM, Stephen Rothwell wrote:
> Hi all,
>
> Today's linux-next merge of the net-next tree got a conflict in
> drivers/net/wireless/ath/ath9k/main.c between commit bcb7ad7bcbef
> ("ath9k: Fix softlockup in AR9485") from the wireless tree and commit
> ef1b6cd9a1ba ("ath9k: Group link monitoring logic") from the net-next
> tree.
>
> The latter removes the code modified by the former, so I did that.  The
> fix from the former patch may be needed elsewhere now.

the back ported version of this patch is recently sent
http://www.spinics.net/lists/linux-wireless/msg92125.html


-- 
thanks,
shafi
