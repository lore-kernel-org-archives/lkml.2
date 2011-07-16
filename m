Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab1GPUTh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 16:19:37 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40238 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab1GPUTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 16:19:36 -0400
Date: Sat, 16 Jul 2011 13:17:33 -0700 (PDT)
Message-Id: <20110716.131733.1746593505234880481.davem@davemloft.net>
To: jkosina@suse.cz
Cc: edt@aei.ca, luiz.dentz@gmail.com, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, padovan@profusion.mobi, iliak@ti.com,
        torvalds@linux-foundation.org
Subject: Re: [BUG] Bluetooth broken post rc7
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.00.1107162141340.7178@twin.jikos.cz>
References: <CABBYNZ+fxUWhi0uF0b_6Z8iqYd7Pp_4zPBRyM6Gyh3zJH1am5Q@mail.gmail.com>
	<201107150728.04355.edt@aei.ca>
	<alpine.LRH.2.00.1107162141340.7178@twin.jikos.cz>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 16 Jul 2011 13:17:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>
Date: Sat, 16 Jul 2011 21:43:06 +0200 (CEST)

> could you please repost the patch with proper changelog and your 
> Signed-off-by, so that it could (hopefully) be applied for 3.0 still?

It's already in my networking tree and on the way to Linus, and has
been so for half a day.
