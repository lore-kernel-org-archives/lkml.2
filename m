Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933634Ab2FASZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 14:25:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43067 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932496Ab2FASZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 14:25:32 -0400
Date: Fri, 01 Jun 2012 14:25:31 -0400 (EDT)
Message-Id: <20120601.142531.544977894901194434.davem@davemloft.net>
To: devendra.aaru@gmail.com
Cc: romieu@fr.zoreil.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] r8169: call netif_napi_del at errpaths and at driver
 unload
From: David Miller <davem@davemloft.net>
In-Reply-To: <1338465080-22720-1-git-send-email-devendra.aaru@gmail.com>
References: <1338465080-22720-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Devendra Naga <devendra.aaru@gmail.com>
Date: Thu, 31 May 2012 17:21:20 +0530

> when register_netdev fails, the init'ed NAPIs by netif_napi_add must be
> deleted with netif_napi_del, and also when driver unloads, it should
> delete the NAPI before unregistering netdevice using unregister_netdev.
> 
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>

Francois, I'm assuming you will merge this to me after you've
done some testing.
