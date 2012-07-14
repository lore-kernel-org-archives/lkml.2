Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109Ab2GNDm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 23:42:27 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40109 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab2GNDm0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 23:42:26 -0400
References: <1342211770-4219-1-git-send-email-silviupopescu1990@gmail.com>
In-Reply-To: <1342211770-4219-1-git-send-email-silviupopescu1990@gmail.com>
Mime-Version: 1.0 (iPhone Mail 8C148)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <EE2B0AEB-F22F-499E-ACD8-0338A487F257@gmail.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
X-Mailer: iPhone Mail (8C148)
From: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>
Subject: Re: [PATCH] mac802154: fix sparse warning for mac802154_slave_get_priv
Date: Sat, 14 Jul 2012 07:42:43 +0400
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Make sparse happy by fixing the following error:
>    * symbol 'mac802154_slave_get_priv' was not declared. Should it be static?
> 
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
> ---
> net/mac802154/mib.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 

Should be already fixed, please try the latest net-next tree.