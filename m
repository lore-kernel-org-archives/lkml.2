Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab2BAThB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:37:01 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:33691 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab2BATg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:36:59 -0500
Date: Wed, 01 Feb 2012 14:36:55 -0500 (EST)
Message-Id: <20120201.143655.1013171439305457146.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: kys@microsoft.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] net/hyperv: Convert camel cased variables in
 rndis_filter.c to lower cases
From: David Miller <davem@davemloft.net>
In-Reply-To: <1327941218-12547-1-git-send-email-haiyangz@microsoft.com>
References: <1327941218-12547-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 01 Feb 2012 11:36:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please do not mix cleanups with real bug fixes.

Patches #4 and #5 in this series fix real bugs, so you should submit them
seperately for inclusion to my 'net' tree.

Once those fixes have propagated to my 'net-next' tree, you can then submit
the cleanups.
