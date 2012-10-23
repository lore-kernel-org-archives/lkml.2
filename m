Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab2JWGw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 02:52:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37459 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab2JWGw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 02:52:56 -0400
Date: Tue, 23 Oct 2012 02:52:55 -0400 (EDT)
Message-Id: <20121023.025255.2203773880954225677.davem@davemloft.net>
To: krzysiek@podlesie.net
Cc: dwmw2@infradead.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] pppoatm: don't send frames to destroyed vcc
From: David Miller <davem@davemloft.net>
In-Reply-To: <1350926091-12642-1-git-send-email-krzysiek@podlesie.net>
References: <1350926091-12642-1-git-send-email-krzysiek@podlesie.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David, if you could review this series I'd really appreciate it.
