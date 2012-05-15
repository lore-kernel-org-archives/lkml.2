Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966001Ab2EORPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 13:15:11 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40286 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964815Ab2EORPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 13:15:08 -0400
Date: Tue, 15 May 2012 13:14:48 -0400 (EDT)
Message-Id: <20120515.131448.1788192704023213475.davem@davemloft.net>
To: JBeulich@suse.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfrm_algo: drop an unnecessary inclusion
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FB2618C0200007800083C99@nat28.tlf.novell.com>
References: <4FB2618C0200007800083C99@nat28.tlf.novell.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 15 May 2012 10:14:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jan Beulich" <JBeulich@suse.com>
Date: Tue, 15 May 2012 13:00:44 +0100

> For several releases, this has not been needed anymore, as no helper
> functions declared in net/ah.h get implemented by xfrm_algo.c anymore.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>

Applied.
