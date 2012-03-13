Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993Ab2CMIEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:04:20 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57064 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757951Ab2CMIEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 04:04:14 -0400
Date: Tue, 13 Mar 2012 01:04:06 -0700 (PDT)
Message-Id: <20120313.010406.769202674785007195.davem@davemloft.net>
To: santoshprasadnayak@gmail.com
Cc: sony.chacko@qlogic.com, rajesh.borundia@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/3 v3] netxen: qlogic ethernet : Fix endian bug.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1331624093-12598-1-git-send-email-santoshprasadnayak@gmail.com>
References: <1331624093-12598-1-git-send-email-santoshprasadnayak@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 13 Mar 2012 01:04:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


You didn't even compile test this.

> -	if (*mac == cpu_to_le64(~0ULL)) {
> +	if (*mac == ~0ULL)) {

This is unacceptable, I'm ignoring you for at least a week.

