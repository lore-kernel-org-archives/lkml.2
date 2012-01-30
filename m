Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab2A3WNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:13:18 -0500
Received: from outmail002.snc4.facebook.com ([66.220.144.136]:59026 "EHLO
	intmgw002.snc4.facebook.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752234Ab2A3WNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:13:17 -0500
Date: Mon, 30 Jan 2012 14:13:10 -0800
From: Arun Sharma <asharma@fb.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, mohan@fb.com,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [v3.3-rc1 regression] TCP: too many of orphaned sockets
Message-ID: <20120130221310.GA10481@dev3310.snc6.facebook.com>
References: <inTpE-FS-29@gated-at.bofh.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <inTpE-FS-29@gated-at.bofh.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Note#2, the message should probably be fixed as well:
> 
>  -   TCP: too many of orphaned sockets                     
>  +   TCP: too many orphaned sockets                     
> 

There is a third problem: we see this message even when the number of
orphaned sockets is below the limit.

I'll send out a patch to disambiguate the message.

 -Arun
