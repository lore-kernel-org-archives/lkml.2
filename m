Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab2FLAGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 20:06:08 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47118 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab2FLAGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 20:06:05 -0400
Date: Mon, 11 Jun 2012 17:06:04 -0700 (PDT)
Message-Id: <20120611.170604.121897369636591046.davem@davemloft.net>
To: pebolle@tiscali.nl
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: remove two unused headers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1339318307.30984.27.camel@x61.thuisdomein>
References: <1339318307.30984.27.camel@x61.thuisdomein>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>
Date: Sun, 10 Jun 2012 10:51:47 +0200

> Nothing includes these two headers. None of the macros they define are
> used anywhere in the tree. This was also the case in v2.6.12-rc2 and,
> presumably, every release in between. These two headers can safely be
> removed.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Applied.
