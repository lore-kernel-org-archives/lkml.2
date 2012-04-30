Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab2D3Rd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 13:33:56 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40925 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920Ab2D3Rdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 13:33:54 -0400
Date: Mon, 30 Apr 2012 13:31:48 -0400 (EDT)
Message-Id: <20120430.133148.1694639055532709407.davem@davemloft.net>
To: bcrl@kvack.org
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/l2tp: fix build error in l2tp from
 missing ipv6 checksum include
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120430172402.GL17021@kvack.org>
References: <20120430155836.44bcf3846c80cf686bb9cb77@canb.auug.org.au>
	<20120430172402.GL17021@kvack.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 30 Apr 2012 10:31:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin LaHaise <bcrl@kvack.org>
Date: Mon, 30 Apr 2012 13:24:02 -0400

> Can you please verify if the patch below fixes the issue?  Thanks.

I already checked a fix into the tree.
