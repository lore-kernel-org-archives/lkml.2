Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab2CMUgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 16:36:32 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:36103 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab2CMUgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 16:36:31 -0400
Date: Tue, 13 Mar 2012 13:34:19 -0700 (PDT)
Message-Id: <20120313.133419.2242081944811028058.davem@davemloft.net>
To: b29396@freescale.com
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com
Subject: Re: [PATCH 1/1] of: add NULL parameter check for
 of_device_is_available
From: David Miller <davem@davemloft.net>
In-Reply-To: <1331638805-17136-1-git-send-email-b29396@freescale.com>
References: <1331638805-17136-1-git-send-email-b29396@freescale.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 13 Mar 2012 13:34:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <b29396@freescale.com>
Date: Tue, 13 Mar 2012 19:40:05 +0800

> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> This function will return 1 even the device node passed in
> is NULL which is a little error-prone.
> Change to return 0 if the device node passed in is NULL.
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>

I think this is a hard error and therefore BUG_ON(!device) is
more appropriate.
