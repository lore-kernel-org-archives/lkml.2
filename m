Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab2BOD51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 22:57:27 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:51990 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab2BOD5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 22:57:25 -0500
Date: Tue, 14 Feb 2012 22:57:13 -0500 (EST)
Message-Id: <20120214.225713.1807433250606231046.davem@davemloft.net>
To: matt@console-pimps.org
Cc: linux-arch@vger.kernel.org, oleg@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, matt.fleming@intel.com,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH 32/40] sparc: Use block_sigmask()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329219673-28711-33-git-send-email-matt@console-pimps.org>
References: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
	<1329219673-28711-33-git-send-email-matt@console-pimps.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 14 Feb 2012 19:57:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt@console-pimps.org>
Date: Tue, 14 Feb 2012 11:41:05 +0000

> From: Matt Fleming <matt.fleming@intel.com>
> 
> Use the new helper function introduced in commit 5e6292c0f28f
> ("signal: add block_sigmask() for adding sigmask to current->blocked")
> which centralises the code for updating current->blocked after
> successfully delivering a signal and reduces the amount of duplicate
> code across architectures. In the past some architectures got this
> code wrong, so using this helper function should stop that from
> happening again.
> 
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: sparclinux@vger.kernel.org
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>

Acked-by: David S. Miller <davem@davemloft.net>
