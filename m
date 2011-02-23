Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab1BWKuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 05:50:21 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:56144 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab1BWKuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 05:50:16 -0500
Date: Wed, 23 Feb 2011 11:46:22 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/2] net/r8169: adjust rtl8169_set_speed_xmii function
Message-ID: <20110223104622.GA12700@electric-eye.fr.zoreil.com>
References: <1298366782-1508-1-git-send-email-hayeswang@realtek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298366782-1508-1-git-send-email-hayeswang@realtek.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll give both series a try this evening before formally Acking-by.
I have no comment left regarding the content itself.

In the future it will help if you add some hint for the target of the
patches. Say [PATCH net-next 1/2] and [PATCH net-next 2/2] for the -next
material (as opposed to the bugfixes).

The messages are strangely threaded here. I'll probably wrap them in
two separate branches.

-- 
Ueimor
