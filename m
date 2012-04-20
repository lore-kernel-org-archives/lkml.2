Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab2DTHGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 03:06:31 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:58045 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab2DTHG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 03:06:29 -0400
Date: Fri, 20 Apr 2012 03:06:07 -0400 (EDT)
Message-Id: <20120420.030607.1891260321280604674.davem@davemloft.net>
To: konrad@gaisler.com
Cc: yong.zhang0@gmail.com, sam@ravnborg.org, a.p.zijlstra@chello.nl,
        mingo@elte.hu, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org, daniel@gaisler.com,
        yong.zhang@windriver.com
Subject: Re: [PATCH 1/1] sparc32,leon: add notify_cpu_starting()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F910312.3010900@gaisler.com>
References: <20120420033634.GA13068@zhy>
	<1334903312-18526-1-git-send-email-konrad@gaisler.com>
	<4F910312.3010900@gaisler.com>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 20 Apr 2012 00:06:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Eisele <konrad@gaisler.com>
Date: Fri, 20 Apr 2012 08:32:50 +0200

> Hello Yong,
> Thank you for the patch, it works. The SMP is fully
> functional again for sparc-leon. I just added a
> "#include<linux/cpu.h>"
> to avoid compiler warning.
> Please someone in the cc-list, apply.

I'll take care of it.
