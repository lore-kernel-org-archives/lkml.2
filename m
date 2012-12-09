Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab2LIFVp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 00:21:45 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42083 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab2LIFVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 00:21:44 -0500
Date: Sun, 09 Dec 2012 00:21:41 -0500 (EST)
Message-Id: <20121209.002141.995257188036827568.davem@davemloft.net>
To: joseph.gasparakis@intel.com
Cc: shemminger@vyatta.com, chrisw@sous-sol.org, gospo@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry@broadcom.com, saeed.bishara@gmail.com,
        bhutchings@solarflare.com
Subject: Re: [PATCH v4 net-next 0/5] tunneling: Add support for
 hardware-offloaded encapsulation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1354925658-24115-1-git-send-email-joseph.gasparakis@intel.com>
References: <1354925658-24115-1-git-send-email-joseph.gasparakis@intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joseph Gasparakis <joseph.gasparakis@intel.com>
Date: Fri,  7 Dec 2012 16:14:13 -0800

> The series contains updates to add in the NIC Rx and Tx checksumming
> support for encapsulated packets.

Ok, all applied (except the ixgbe patch, of course), thanks.
