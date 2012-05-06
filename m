Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab2EFUcy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 16:32:54 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:42517 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab2EFUcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 16:32:53 -0400
Date: Sun, 06 May 2012 16:32:43 -0400 (EDT)
Message-Id: <20120506.163243.1653904376439925642.davem@davemloft.net>
To: hpa@zytor.com
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, ralf@linux-mips.org
Subject: Re: [PATCH] broken TASK_SIZE for ia32_aout
From: David Miller <davem@davemloft.net>
In-Reply-To: <b73ca203-c9d8-4ca3-b680-d00499f284cd@email.android.com>
References: <4FA6BBD9.3040308@zytor.com>
	<20120506184641.GW6871@ZenIV.linux.org.uk>
	<b73ca203-c9d8-4ca3-b680-d00499f284cd@email.android.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 06 May 2012 13:32:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 06 May 2012 11:48:15 -0700

> I would argue Sparc is not correct here but I am not a Sparc expert.

I can easily make sparc take on the x86 behavior if things like the
input layer really need it.

However, isn't the input layer case a case where compat==native
on anything other than x86 because it's a u64 alignment issue?
