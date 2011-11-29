Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab1K2Tfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 14:35:52 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:42374 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab1K2Tfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 14:35:51 -0500
Date: Tue, 29 Nov 2011 14:39:50 -0500 (EST)
Message-Id: <20111129.143950.406285357.davem@davemloft.net>
To: xi.wang@gmail.com
Cc: linux-kernel@vger.kernel.org, vladislav.yasevich@hp.com, sri@us.ibm.com,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        security@kernel.org
Subject: Re: [PATCH] sctp: integer overflow in sctp_auth_create_key()
From: David Miller <davem@davemloft.net>
In-Reply-To: <BC344CCF-A50F-4E5E-A9A5-F506D8BD9DB9@gmail.com>
References: <028246D6-9024-4E43-93A1-25A87878CBBC@gmail.com>
	<20111129.011932.1501413448765180498.davem@davemloft.net>
	<BC344CCF-A50F-4E5E-A9A5-F506D8BD9DB9@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 29 Nov 2011 11:35:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xi Wang <xi.wang@gmail.com>
Date: Tue, 29 Nov 2011 14:31:30 -0500

> a5e5c374 --- it says "No differences found".
> 
> Can you please apply the new patch v2?  Thanks.

Sigh, probably a side effect of how your patch was corrupted
and how I tried to fix it up by hand :-/

Ok, I'll apply v2, thanks.
