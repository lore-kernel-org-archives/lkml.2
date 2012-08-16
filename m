Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab2HPWLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 18:11:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35924 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab2HPWLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 18:11:46 -0400
Date: Thu, 16 Aug 2012 15:11:45 -0700 (PDT)
Message-Id: <20120816.151145.1545241222143797093.davem@davemloft.net>
To: john.r.fastabend@intel.com
Cc: viro@ZenIV.linux.org.uk, nhorman@tuxdriver.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joe@perches.com
Subject: Re: [net PATCH v3 1/3] net: netprio: fix files lock and remove
 useless d_path bits
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120814223424.3551.21608.stgit@jf-dev1-dcblab>
References: <20120814223424.3551.21608.stgit@jf-dev1-dcblab>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Fastabend <john.r.fastabend@intel.com>
Date: Tue, 14 Aug 2012 15:34:24 -0700

> Add lock to prevent a race with a file closing and also remove
> useless and ugly sscanf code. The extra code was never needed
> and the case it supposedly protected against is in fact handled
> correctly by sock_from_file as pointed out by Al Viro.
> 
> CC: Neil Horman <nhorman@tuxdriver.com>
> Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
> Signed-off-by: John Fastabend <john.r.fastabend@intel.com>

Applied.
