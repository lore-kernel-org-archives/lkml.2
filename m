Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962Ab0JYQAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:00:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35114
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756798Ab0JYQAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:00:20 -0400
Date: Mon, 25 Oct 2010 09:00:43 -0700 (PDT)
Message-Id: <20101025.090043.71110898.davem@davemloft.net>
To: namhyung@gmail.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] sparc32: fix build failure on CONFIG_SPARC_LEON
From: David Miller <davem@davemloft.net>
In-Reply-To: <1288021958-3130-3-git-send-email-namhyung@gmail.com>
References: <1288021958-3130-1-git-send-email-namhyung@gmail.com>
	<1288021958-3130-3-git-send-email-namhyung@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>
Date: Tue, 26 Oct 2010 00:52:38 +0900

>   CC      arch/sparc/kernel/irq_32.o
> arch/sparc/kernel/irq_32.c: In function 'request_fast_irq':
> arch/sparc/kernel/irq_32.c:370:25: error: conflicting types for 'trapbase_cpu1'

I doubt SMP LEON chips even exist, so better to just anti-dep
this in arch/sparc/Kconfig
