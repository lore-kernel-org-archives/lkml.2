Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760834Ab2FDPsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:48:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40459 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab2FDPsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:48:07 -0400
Date: Mon, 04 Jun 2012 11:48:03 -0400 (EDT)
Message-Id: <20120604.114803.742884170282591530.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: [PATCH 1/1] net/hyperv: Use wait_event on outstanding sends
 during device removal
From: David Miller <davem@davemloft.net>
In-Reply-To: <1338820532-2345-2-git-send-email-haiyangz@microsoft.com>
References: <1338820532-2345-1-git-send-email-haiyangz@microsoft.com>
	<1338820532-2345-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Mon,  4 Jun 2012 07:35:32 -0700

> +	wait_event(net_device->wait_drain,
> +		atomic_read(&net_device->num_outstanding_sends) == 0);

Please indent this properly.  The goal is not to indent using only
TAB characters, the goal is to line things up to the proper column
using TAB and space characters as needed.

You must make the first character on the second line be at the
first column after the openning parenthesis on the previous line.
