Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab2CYR3X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 13:29:23 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:50622 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab2CYR3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 13:29:22 -0400
Date: Sun, 25 Mar 2012 13:29:13 -0400 (EDT)
Message-Id: <20120325.132913.1085823688400645918.davem@davemloft.net>
To: paul.gortmaker@windriver.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        afleming@freescale.com, joe@perches.com
Subject: Re: [PATCH v2] gianfar: Fix possible overrun and simplify
 interrupt name field creation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1332695407-21167-1-git-send-email-paul.gortmaker@windriver.com>
References: <CAP=VYLrPbYv2C7hYaQ-aUJLFCfYh5zkJzFXJt8GFV2OTZ7h=og@mail.gmail.com>
	<1332695407-21167-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 25 Mar 2012 10:29:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Sun, 25 Mar 2012 13:10:07 -0400

> From: Joe Perches <joe@perches.com>
> 
> Space allocated for int_name_<foo> is insufficient for
> maximal device name, expand it.
> 
> Code to create int_name_<foo> is obscure, simplify it
> by using sprintf.
> 
> Found by looking for unnecessary \ line continuations.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> Tested-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Applied.
