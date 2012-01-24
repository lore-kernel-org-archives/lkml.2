Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab2AXWoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:44:23 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:42775 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab2AXWoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:44:22 -0500
Date: Tue, 24 Jan 2012 17:44:11 -0500 (EST)
Message-Id: <20120124.174411.461005676894214362.davem@davemloft.net>
To: sjur.brandeland@stericsson.com
Cc: levinsasha928@gmail.com, linux-kernel@vger.kernel.org, davej@redhat.com,
        sjurbren@gmail.com
Subject: Re: [PATCH net] caif: Fix crash due to uninitialized net
 name-space.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1327444045-1033-1-git-send-email-sjur.brandeland@stericsson.com>
References: <CA+1xoqdZapYjS4gPf_uGwEdFQQdZ525mASr7iFKPXJdCBdRLKA@mail.gmail.com>
	<1327444045-1033-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 24 Jan 2012 14:44:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please post all networking patches CC:'d to netdev@vger.kernel.org
