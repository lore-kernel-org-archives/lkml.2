Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751030Ab2EIEJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 00:09:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34662 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab2EIEJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 00:09:10 -0400
Date: Wed, 9 May 2012 01:09:01 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Eldad Zack <eldad@fogrefinery.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/bluetooth/bnep/core.c: use constant for ethertype
Message-ID: <20120509040901.GC2362@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Eldad Zack <eldad@fogrefinery.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1336428575-28996-1-git-send-email-eldad@fogrefinery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336428575-28996-1-git-send-email-eldad@fogrefinery.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eldad,

* Eldad Zack <eldad@fogrefinery.com> [2012-05-08 00:09:35 +0200]:

> The dot1q ethertype number (0x8100) is embedded in the code, although
> it is already defined in included headers.
> 
> Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
> ---
>  net/bluetooth/bnep/core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch has been applied to bluetooth-next. Thanks.

	Gustavo
