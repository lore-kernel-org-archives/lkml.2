Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab0INC6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 22:58:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540Ab0INC6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 22:58:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
X-Fcc: ~/Mail/linus
Cc: monstr@monstr.eu, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 14/24] ptrace: cleanup arch_ptrace() on microblaze
In-Reply-To: Namhyung Kim's message of  Tuesday, 14 September 2010 11:39:24 +0900 <AANLkTinceMB0YKcaCBSo9qnt2uZngf3gbuDzB4tPDCMc@mail.gmail.com>
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
	<1283442391-23612-15-git-send-email-namhyung@gmail.com>
	<4C8DCF72.4050701@monstr.eu>
	<AANLkTi=oHVCoeuz20qkBHTUDEwTEDsN4mFdR8nE+CaNk@mail.gmail.com>
	<20100914021532.9C53E403E6@magilla.sf.frob.com>
	<AANLkTikWqmxob31RjTxu3zwypxJ29KO=zVEko-157iLB@mail.gmail.com>
	<20100914023129.8ACE9403E6@magilla.sf.frob.com>
	<AANLkTinceMB0YKcaCBSo9qnt2uZngf3gbuDzB4tPDCMc@mail.gmail.com>
Emacs: Our Lady of Perpetual Garbage Collection
Message-Id: <20100914025831.0D486403E6@magilla.sf.frob.com>
Date: Mon, 13 Sep 2010 19:58:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK. That means I can add your Acked-by's on architecture independent
> part in this series
> which are 01, 03 and (resended) 02, right?

Yes, those alone should not change the compiled code at all.
If that's so, then they are certainly fine with me.


Thanks,
Roland
