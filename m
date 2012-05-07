Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab2EGC4r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 22:56:47 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44031 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205Ab2EGC4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 22:56:46 -0400
Date: Sun, 06 May 2012 22:56:39 -0400 (EDT)
Message-Id: <20120506.225639.74405234456670944.davem@davemloft.net>
To: hpa@zytor.com
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, ralf@linux-mips.org
Subject: Re: [PATCH] broken TASK_SIZE for ia32_aout
From: David Miller <davem@davemloft.net>
In-Reply-To: <8c91e0ff-dc31-4f94-8008-33d8c3d3c8ef@email.android.com>
References: <af01067e-5a22-44a8-acb1-368e45dbb06c@email.android.com>
	<20120506.194037.1148847080889462521.davem@davemloft.net>
	<8c91e0ff-dc31-4f94-8008-33d8c3d3c8ef@email.android.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 06 May 2012 19:56:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 06 May 2012 16:48:00 -0700

> Why not just make it illegal to make the system calls you don't care
> about then, to prevent any security issue?

I'll take a closer look tomorrow.

BTW, when did you start top-posting? :-/
