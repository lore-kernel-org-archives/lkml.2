Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab2AQPIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 10:08:22 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:54439 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab2AQPIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 10:08:21 -0500
Date: Tue, 17 Jan 2012 10:08:13 -0500 (EST)
Message-Id: <20120117.100813.1857344711295512911.davem@davemloft.net>
To: devendra.aaru@gmail.com
Cc: jesse@nicira.com, dev@openvswitch.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] remove version.h includes in net/openvswitch/
From: David Miller <davem@davemloft.net>
In-Reply-To: <1326564981-7142-1-git-send-email-devendra.aaru@gmail.com>
References: <1326564981-7142-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 17 Jan 2012 07:08:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Devendra Naga <devendra.aaru@gmail.com>
Date: Sat, 14 Jan 2012 23:46:21 +0530

> remove version.h includes in net/openswitch/ as reported by make versioncheck.
> 
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>

Applied, thanks.
