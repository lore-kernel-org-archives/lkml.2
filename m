Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965125Ab2JWUOB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:14:01 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44087 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964956Ab2JWUN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:13:56 -0400
Date: Tue, 23 Oct 2012 16:13:54 -0400 (EDT)
Message-Id: <20121023.161354.681368386879438466.davem@davemloft.net>
To: keescook@chromium.org
Cc: linux-kernel@vger.kernel.org, vyasevich@gmail.com, sri@us.ibm.com
Subject: Re: [PATCH 181/193] net/sctp: remove CONFIG_EXPERIMENTAL
From: David Miller <davem@davemloft.net>
In-Reply-To: <1351022666-6960-182-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	<1351022666-6960-182-git-send-email-keescook@chromium.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Date: Tue, 23 Oct 2012 13:04:14 -0700

> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
> 
> CC: Vlad Yasevich <vyasevich@gmail.com>
> CC: Sridhar Samudrala <sri@us.ibm.com>
> CC: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: David S. Miller <davem@davemloft.net>
