Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab2ACSGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 13:06:43 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:41085 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab2ACSGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 13:06:42 -0500
Date: Tue, 03 Jan 2012 13:05:26 -0500 (EST)
Message-Id: <20120103.130526.2034128205205666131.davem@davemloft.net>
To: nhorman@tuxdriver.com
Cc: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        bhelgaas@google.com, gregkh@suse.de, linux-pci@vger.kernel.org
Subject: Re: [PATCH] msi: fix imbalanced refcount of msi irq sysfs objects
From: David Miller <davem@davemloft.net>
In-Reply-To: <1325604594-7184-1-git-send-email-nhorman@tuxdriver.com>
References: <1325604594-7184-1-git-send-email-nhorman@tuxdriver.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 03 Jan 2012 10:05:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue,  3 Jan 2012 10:29:54 -0500

> This warning was recently reported to me:

I've hit this too, see:

http://marc.info/?l=linux-kernel&m=132458146927890&w=2

and my analysis at:

http://marc.info/?l=linux-arch&m=132458391128660&w=2
