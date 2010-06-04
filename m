Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702Ab0FDXRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 19:17:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39801
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757289Ab0FDXRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 19:17:40 -0400
Date: Fri, 04 Jun 2010 16:17:50 -0700 (PDT)
Message-Id: <20100604.161750.70215425.davem@davemloft.net>
To: julia@diku.dk
Cc: grant.likely@secretlab.ca, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/11] arch/sparc/kernel: Eliminate what looks like a
 NULL pointer dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.1005271432250.5422@ask.diku.dk>
References: <Pine.LNX.4.64.1005271432250.5422@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Thu, 27 May 2010 14:32:45 +0200 (CEST)

> From: Julia Lawall <julia@diku.dk>
> 
> At the point of the test, action cannot be NULL, as it has been dereferenced
> in the code just above.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied, thanks Julia.
