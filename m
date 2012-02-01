Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab2BAHBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 02:01:14 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:56138 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab2BAHBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 02:01:12 -0500
Date: Wed, 01 Feb 2012 01:59:54 -0500 (EST)
Message-Id: <20120201.015954.2098592611164231843.davem@davemloft.net>
To: lizf@cn.fujitsu.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, nhorman@tuxdriver.com
Subject: Re: [PATCH 4/6] netprio_cgroup: use IS_ENABLED() and family
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F28E203.10502@cn.fujitsu.com>
References: <4F28E1D1.900@cn.fujitsu.com>
	<4F28E203.10502@cn.fujitsu.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 31 Jan 2012 22:59:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Do not mix genuine bug fixes and cleanups.

Otherwise I cannot apply your bug fixes to the 'net' tree.

Seperate things out, submit only pure bug fixes first, then
later once those changes propagate you can submit the cleanups.
