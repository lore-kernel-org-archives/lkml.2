Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201Ab1FGFx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 01:53:27 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38893 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab1FGFx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 01:53:26 -0400
Date: Mon, 06 Jun 2011 22:53:21 -0700 (PDT)
Message-Id: <20110606.225321.625955055583754790.davem@davemloft.net>
To: Gregory.Dietsche@cuw.edu
Cc: ron.mercer@qlogic.com, linux-driver@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] qlge: remove unecessary if statement
From: David Miller <davem@davemloft.net>
In-Reply-To: <1307321053-21695-1-git-send-email-Gregory.Dietsche@cuw.edu>
References: <1307321053-21695-1-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 06 Jun 2011 22:53:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Date: Sun,  5 Jun 2011 19:44:13 -0500

> the code always returns 'status' regardless, so if(status) check is unecessary.
> 
> Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>

Applied, thanks.
