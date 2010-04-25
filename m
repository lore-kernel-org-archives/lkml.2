Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab0DYO6u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 10:58:50 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:58888 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384Ab0DYO6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 10:58:37 -0400
To: manuel.lauss@googlemail.com, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.34-rc5+: oops in IPv6
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <z2if861ec6f1004250745u94892bdbw9b17db4be57b131b@mail.gmail.com>
In-Reply-To: <z2if861ec6f1004250745u94892bdbw9b17db4be57b131b@mail.gmail.com>
Message-Id: <201004252358.EHF35423.FHOVJOtLMOFFQS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 25 Apr 2010 23:58:32 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manuel Lauss wrote:
> 2.6.34-rc5-00204-gddc9b34  dies when sshd (openssh 5.5) is started
> Last pull I made on April 23 was fine.

This seems a regression introduced while handling
"PROBLEM: Linux kernel 2.6.31 IPv4 TCP fails to open hugeamount of outgoing connections (unable to bind ... )"
problem. It is in https://bugzilla.kernel.org/show_bug.cgi?id=15847 .

Regards.
