Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab1JTVMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:12:31 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35583 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab1JTVMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:12:30 -0400
Date: Thu, 20 Oct 2011 17:12:20 -0400 (EDT)
Message-Id: <20111020.171220.590110051530207341.davem@davemloft.net>
To: ricardo.ribalda@gmail.com
Cc: ian.campbell@citrix.com, jeffrey.t.kirsher@intel.com,
        grant.likely@secretlab.ca, jpirko@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] ll_temac: Add support for ethtool
From: David Miller <davem@davemloft.net>
In-Reply-To: <1319009725-7869-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1319009725-7869-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 20 Oct 2011 14:12:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 19 Oct 2011 09:35:25 +0200

> This patch enables the ethtool interface. The implementation is done
> using the libphy helper functions.

Applied, thanks.

In the future, please put the reviewed-by and signoffs before the "---"
otherwise automated tools will omit it from the final commit message.
