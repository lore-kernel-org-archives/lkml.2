Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab0LHS1E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 13:27:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34428
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756012Ab0LHS1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 13:27:02 -0500
Date: Wed, 08 Dec 2010 10:27:29 -0800 (PST)
Message-Id: <20101208.102729.115929908.davem@davemloft.net>
To: joe.jin@oracle.com
Cc: sathyap@serverengines.com, subbus@serverengines.com,
        sarveshwarb@serverengines.com, ajitk@serverengines.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        greg.marsden@oracle.com, guru.anbalagane@oracle.com
Subject: Re: [patch 1/1] driver/net/benet: fix be_cmd_multicast_set()
 memcpy bug
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101206130059.GA19448@joejin-pc.cn.oracle.com>
References: <20101206130059.GA19448@joejin-pc.cn.oracle.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Jin <joe.jin@oracle.com>
Date: Mon, 6 Dec 2010 21:00:59 +0800

> Hi, 
> 
> Regarding  benet be_cmd_multicast_set() function, now using
> netdev_for_each_mc_addr() helper for mac address copy, but
> when copying to req->mac[] did not increase of the index.
> 
> Cc: Sathya Perla <sathyap@serverengines.com>
> Cc: Subbu Seetharaman <subbus@serverengines.com>
> Cc: Sarveshwar Bandi <sarveshwarb@serverengines.com>
> Cc: Ajit Khaparde <ajitk@serverengines.com>
> Signed-off-by: Joe Jin <joe.jin@oracle.com>

Applied, thank you.
