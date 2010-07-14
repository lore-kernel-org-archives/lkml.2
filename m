Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab0GNWH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 18:07:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57577
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757361Ab0GNWHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 18:07:24 -0400
Date: Wed, 14 Jul 2010 15:07:39 -0700 (PDT)
Message-Id: <20100714.150739.193711125.davem@davemloft.net>
To: segooon@gmail.com
Cc: kernel-janitors@vger.kernel.org, grundler@parisc-linux.org,
        kyle@mcmartin.ca, joe@perches.com, jpirko@redhat.com,
        ben@decadent.org.uk, grant.likely@secretlab.ca, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 05/11] tulip: formatting of pointers in printk()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1279130568-10857-1-git-send-email-segooon@gmail.com>
References: <1279130568-10857-1-git-send-email-segooon@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kulikov Vasiliy <segooon@gmail.com>
Date: Wed, 14 Jul 2010 22:02:47 +0400

> Use %p instead of %08x in printk().
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>

Since patch #5 and #6 are doing the same change to different
files in the same driver, I combined them into one commit.

There is no need to split things up with so much granularity.
If it's all in the same driver, doing the same transformation,
keep it all in one patch.

Thanks.
