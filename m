Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab0HZD4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 23:56:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51438
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752969Ab0HZDz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 23:55:59 -0400
Date: Wed, 25 Aug 2010 20:56:13 -0700 (PDT)
Message-Id: <20100825.205613.98875749.davem@davemloft.net>
To: horms@verge.net.au
Cc: julia@diku.dk, wensong@linux-vs.org, ja@ssi.bg, kaber@trash.net,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/5] net/netfilter/ipvs: Eliminate memory leak
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100826003204.GA9771@verge.net.au>
References: <20100825013443.GC7237@verge.net.au>
	<20100825.163812.242150096.davem@davemloft.net>
	<20100826003204.GA9771@verge.net.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Horman <horms@verge.net.au>
Date: Thu, 26 Aug 2010 09:32:05 +0900

> I have a handful of other changes queued up,
> do you want to take them too?

Sure, let's do that.
