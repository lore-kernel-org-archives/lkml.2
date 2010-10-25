Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab0JYFZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 01:25:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50238
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751150Ab0JYFZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 01:25:39 -0400
Date: Sun, 24 Oct 2010 22:26:02 -0700 (PDT)
Message-Id: <20101024.222602.71095343.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, shemminger@vyatta.com,
        jchapman@katalix.com
Subject: Re: linux-next: build failure after merge of the final tree
 (net-current tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101025141956.d8f0888f.sfr@canb.auug.org.au>
References: <20101025141956.d8f0888f.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 25 Oct 2010 14:19:56 +1100

> I wish doing that caused a build failure on other architectures ...

Me too :-/

> Subject: [PATCH] l2tp: static functions should not be exported

I'll add this thanks Stephen.
