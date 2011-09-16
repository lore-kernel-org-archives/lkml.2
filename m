Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab1IPOHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 10:07:52 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:58928 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab1IPOHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 10:07:51 -0400
X-Nat-Received: from [202.181.97.72]:54544 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1316182058.2046
To: nab@linux-iscsi.org
Cc: zohar@linux.vnet.ibm.com, andy.shevchenko@gmail.com,
        safford@watson.ibm.com, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 5/5] target: check hex2bin result
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1316177430-13167-1-git-send-email-zohar@linux.vnet.ibm.com>
	<1316177430-13167-5-git-send-email-zohar@linux.vnet.ibm.com>
In-Reply-To: <1316177430-13167-5-git-send-email-zohar@linux.vnet.ibm.com>
Message-Id: <201109162307.FFF57890.OSFOtFLHJQVOMF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 16 Sep 2011 23:07:35 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 16092011 #6004142, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar wrote:
> Now that hex2bin does error checking, on error add debugging error msg.

We are waiting for response from Nicholas, aren't we?
Quotuing from http://www.spinics.net/linux/fedora/linux-security-module/msg11570.html :
| I was assuming that, by adding error check, hex2bin() will leave the buffer
| uninitialized in case of bad input because hex2bin() user in Linux 3.0 can
| return errors. Now you are a new user of hex2bin() but your code cannot return
| errors. Nicholas, how do you want to handle bad input?
