Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442Ab2CGErr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 23:47:47 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:42969 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759030Ab2CGErq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 23:47:46 -0500
Date: Tue, 06 Mar 2012 23:47:34 -0500 (EST)
Message-Id: <20120306.234734.1508316807241059857.davem@davemloft.net>
To: john@stoffel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: Why does NET_VENDOR_DEC default to y?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20310.57932.964124.347872@quad.stoffel.home>
References: <20310.57932.964124.347872@quad.stoffel.home>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 06 Mar 2012 20:47:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The new "vendor" Kconfig guards default to 'y', not the drivers
themselves.
