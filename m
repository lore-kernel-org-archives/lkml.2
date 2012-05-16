Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966594Ab2EPFAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 01:00:04 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45324 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab2EPFAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 01:00:01 -0400
Date: Wed, 16 May 2012 00:59:57 -0400 (EDT)
Message-Id: <20120516.005957.867101981297584239.davem@davemloft.net>
To: paul.gortmaker@windriver.com
Cc: ddaney.cavm@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, david.daney@cavium.com
Subject: Re: [PATCH] netdev/phy: Make get_phy_id() static and quit
 EXPORTing it.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120515213208.GD17760@windriver.com>
References: <1337114812-3912-1-git-send-email-ddaney.cavm@gmail.com>
	<20120515213208.GD17760@windriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 15 May 2012 21:59:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Tue, 15 May 2012 17:32:08 -0400

> [[PATCH] netdev/phy: Make get_phy_id() static and quit EXPORTing it.] On 15/05/2012 (Tue 13:46) David Daney wrote:
> 
>> From: David Daney <david.daney@cavium.com>
>> 
>> This function is only referenced from within phy_device.c, so there is
>> no reason to export it.  In fact, we can make it static.
> 
> I did a bit of data mining to remind myself why it was exported.  Back
> in a01b3d766c (v2.6.26) gianfar_mii was using it.  That then got merged
> into fsl_pq_mdio.c and gianfar_mii was deleted.  Then finally in commit
> 28d8ea2d568 (v3.2) the one instance of code that was using it got
> removed.  So, I think this should be OK (but for net-next, though).
> 
> Acked-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Applied.
