Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965926Ab2EORKC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 13:10:02 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40224 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758347Ab2EORKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 13:10:00 -0400
Date: Tue, 15 May 2012 13:08:22 -0400 (EDT)
Message-Id: <20120515.130822.1034077000097535022.davem@davemloft.net>
To: arnd@arndb.de
Cc: geert@linux-m68k.org, jbohac@suse.cz, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3.4-rc7 regression] net/bond: return int from
 recv_probe()
From: David Miller <davem@davemloft.net>
In-Reply-To: <201205151056.53621.arnd@arndb.de>
References: <20120512200901.811D37C0074@ra.kernel.org>
	<CAMuHMdVuDC7LiYuOdVELsxbbyf1PVZ-QvHY_7pUxigk+DWfysg@mail.gmail.com>
	<201205151056.53621.arnd@arndb.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 15 May 2012 10:08:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Also there were illegal sequences in your email headers (the netdev
address has a trailing ".") so vger rejected the posting.
