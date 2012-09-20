Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab2ITWJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 18:09:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39936 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab2ITWJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 18:09:51 -0400
Date: Thu, 20 Sep 2012 18:09:49 -0400 (EDT)
Message-Id: <20120920.180949.2287169159603922703.davem@davemloft.net>
To: minipli@googlemail.com
Cc: steffen.klassert@secunet.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] xfrm_user info leaks
From: David Miller <davem@davemloft.net>
In-Reply-To: <1348090423-32665-1-git-send-email-minipli@googlemail.com>
References: <1348090423-32665-1-git-send-email-minipli@googlemail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Krause <minipli@googlemail.com>
Date: Wed, 19 Sep 2012 23:33:37 +0200

> the following series fixes various info leaks in the xfrm netlink
> interface. As always, a test case can be supplied on request.
> 
> Patches 1 to 5 are probably material for stable, too. Patch 6 is just a
> minor optimization I stumbled across while auditing the code.
> 
> Please apply!

All applied, and I made sure to use v3 of patch #5 (which you marked
as 5/7 instead of 5/6 :-)

Also, these have been queued up for -stable as well.

Thanks.
