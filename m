Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab2F2Wg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 18:36:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38755 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab2F2Wg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 18:36:57 -0400
Date: Fri, 29 Jun 2012 15:36:56 -0700 (PDT)
Message-Id: <20120629.153656.1141845894730637434.davem@davemloft.net>
To: vincent.sanders@collabora.co.uk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: AF_BUS socket address family
From: David Miller <davem@davemloft.net>
In-Reply-To: <1340988354-26981-1-git-send-email-vincent.sanders@collabora.co.uk>
References: <1340988354-26981-1-git-send-email-vincent.sanders@collabora.co.uk>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is no extensive text describing why using IPv4 for this cannot
be done.  I can almost bet that nobody really, honestly, tried.

Basically this means all of our feedback from the last time we had
discussions on kernel IPC for DBUS are being completely ignored.

Therefore, I will completely ignore this patch submission.

