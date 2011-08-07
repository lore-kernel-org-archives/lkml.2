Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab1HGWmN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 18:42:13 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43745 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab1HGWmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 18:42:10 -0400
Date: Sun, 07 Aug 2011 15:41:37 -0700 (PDT)
Message-Id: <20110807.154137.1593570736451213760.davem@davemloft.net>
To: rjw@sisk.pl
Cc: msb@chromium.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, magnus.damm@gmail.com,
        lethal@linux-sh.org, linux-sh@vger.kernel.org
Subject: Re: [Regression] Boot crash caused by commit
 1eb19a12bd2214cdcad5273d472b062a4ba97fa1
From: David Miller <davem@davemloft.net>
In-Reply-To: <201108080031.26165.rjw@sisk.pl>
References: <201108080031.26165.rjw@sisk.pl>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 07 Aug 2011 15:41:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Mon, 8 Aug 2011 00:31:25 +0200

> Hi,
> 
> Unfortuately, your commit 1eb19a12bd2214cdcad5273d472b062a4ba97fa1
> (lib/sha1: use the git implementation of SHA-1) causes one of my test
> systems, which is an ARM shmobile Mackerel development boards, to crash
> during boot (due to referencing invalid addresses AFAICS).
> 
> Please fix or revert.

It's already been fixed by removing the ARM specific SHA1 assembler,
simply repull.
