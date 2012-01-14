Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab2ANIPd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 03:15:33 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:53781 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab2ANIP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 03:15:29 -0500
Date: Sat, 14 Jan 2012 00:15:25 -0800 (PST)
Message-Id: <20120114.001525.2158050844390627233.davem@davemloft.net>
To: dvhart@linux.intel.com
Cc: linux-kernel@vger.kernel.org, arjan@linux.intel.com, alan@linux.intel.com,
        tomoya.rohm@gmail.com, jeffrey.t.kirsher@intel.com,
        paul.gortmaker@windriver.com, jdmason@kudzu.us, netdev@vger.kernel.org
Subject: Re: [PATCH] pch_gbe: Use a randomly generated MAC instead of
 failing probe
From: David Miller <davem@davemloft.net>
In-Reply-To: <132d2a41a089905de3147b4656e350608aa7fd6f.1326523495.git.dvhart@linux.intel.com>
References: <132d2a41a089905de3147b4656e350608aa7fd6f.1326523495.git.dvhart@linux.intel.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 14 Jan 2012 00:15:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Hart <dvhart@linux.intel.com>
Date: Fri, 13 Jan 2012 22:44:55 -0800

> CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com> (commit_signer:1/3=33%,commit_signer:1/8=12%)

BTW, please try to figure out where this "commit_signer" stuff came from.

It ended up corrupting the CC: list of your posting too.
