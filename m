Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab0LHSZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 13:25:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42280
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756093Ab0LHSZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 13:25:07 -0500
Date: Wed, 08 Dec 2010 10:25:34 -0800 (PST)
Message-Id: <20101208.102534.59676955.davem@davemloft.net>
To: mmarek@suse.cz
Cc: jchapman@katalix.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] l2tp: Fix modalias of l2tp_ip
From: David Miller <davem@davemloft.net>
In-Reply-To: <1291639152-26608-1-git-send-email-mmarek@suse.cz>
References: <1291639152-26608-1-git-send-email-mmarek@suse.cz>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Marek <mmarek@suse.cz>
Date: Mon,  6 Dec 2010 13:39:12 +0100

> Using the SOCK_DGRAM enum results in
> "net-pf-2-proto-SOCK_DGRAM-type-115", so use the numeric value like it
> is done in net/dccp.
> 
> Signed-off-by: Michal Marek <mmarek@suse.cz>

Applied, thank you.
