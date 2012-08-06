Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab2HFUaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 16:30:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38918 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab2HFUaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 16:30:09 -0400
Date: Mon, 06 Aug 2012 13:30:08 -0700 (PDT)
Message-Id: <20120806.133008.1786133868751305467.davem@davemloft.net>
To: silviupopescu1990@gmail.com
Cc: netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp_output: fix sparse warning for tcp_wfree
From: David Miller <davem@davemloft.net>
In-Reply-To: <1344108689-17896-1-git-send-email-silviupopescu1990@gmail.com>
References: <1344108689-17896-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Date: Sat,  4 Aug 2012 22:31:29 +0300

> Fix sparse warning:
> 	* symbol 'tcp_wfree' was not declared. Should it be static?
> 
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>

Applied.
