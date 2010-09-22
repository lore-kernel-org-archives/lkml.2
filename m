Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016Ab0IVBHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 21:07:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54211
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756721Ab0IVBHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 21:07:47 -0400
Date: Tue, 21 Sep 2010 18:08:07 -0700 (PDT)
Message-Id: <20100921.180807.102548362.davem@davemloft.net>
To: andy.shevchenko@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org
Subject: Re: [PATCHv1.5 2/3] sunrpc/cache: don't use custom hex_to_bin()
 converter
From: David Miller <davem@davemloft.net>
In-Reply-To: <9ff9c1f334999e0128fe6426aaad4e9d465f310f.1285051188.git.andy.shevchenko@gmail.com>
References: <2d00b66224535ae82be1a1e638b86b81fb890f58.1285051188.git.andy.shevchenko@gmail.com>
	<2d00b66224535ae82be1a1e638b86b81fb890f58.1285051188.git.andy.shevchenko@gmail.com>
	<9ff9c1f334999e0128fe6426aaad4e9d465f310f.1285051188.git.andy.shevchenko@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Tue, 21 Sep 2010 09:40:25 +0300

> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
> Cc: linux-nfs@vger.kernel.org

I'll let the NFS folks pick this one up.
