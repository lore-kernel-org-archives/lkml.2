Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935405Ab1JEVvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 17:51:43 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60902 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499Ab1JEVvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 17:51:42 -0400
Date: Wed, 05 Oct 2011 17:50:19 -0400 (EDT)
Message-Id: <20111005.175019.1707448511283364180.davem@davemloft.net>
To: nathan@traverse.com.au
Cc: netdev@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] atm: solos-pci: Add AnnexA/M capability attributes
From: David Miller <davem@davemloft.net>
In-Reply-To: <1317789810.2424.82.camel@dualcore.traverse>
References: <1317789810.2424.82.camel@dualcore.traverse>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 05 Oct 2011 14:50:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathan Williams <nathan@traverse.com.au>
Date: Wed, 05 Oct 2011 15:43:30 +1100

> BisACapability and BisMCapability allow users to
> force either Annex A or Annex M.
> 
> Signed-off-by: Nathan Williams <nathan@traverse.com.au>

David, Nathan's patches look fine to me, want me to stick them into
net-next?
