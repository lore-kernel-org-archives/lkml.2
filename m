Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab0CRGVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 02:21:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48183
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752151Ab0CRGVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 02:21:16 -0400
Date: Wed, 17 Mar 2010 23:21:38 -0700 (PDT)
Message-Id: <20100317.232138.183064506.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: linux-next: build failure after merge of the final tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100318160220.b7eaded6.sfr@canb.auug.org.au>
References: <20100318160220.b7eaded6.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 18 Mar 2010 16:02:20 +1100

> Caused by commit 23606cf5d1192c2b17912cb2ef6e62f9b11de133 ("e1000e /
> PCI / PM: Add basic runtime PM support (rev. 4)") from the net tree.

I have a fix for this pushed to net-next-2.6 and I'm sure
Tom will have a fix for the rps UP build failure soon too.

Thanks!
