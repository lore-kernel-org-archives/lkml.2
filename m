Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab0INCbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 22:31:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847Ab0INCbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 22:31:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
X-Fcc: ~/Mail/linus
Cc: monstr@monstr.eu, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 14/24] ptrace: cleanup arch_ptrace() on microblaze
In-Reply-To: Namhyung Kim's message of  Tuesday, 14 September 2010 11:27:55 +0900 <AANLkTikWqmxob31RjTxu3zwypxJ29KO=zVEko-157iLB@mail.gmail.com>
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
	<1283442391-23612-15-git-send-email-namhyung@gmail.com>
	<4C8DCF72.4050701@monstr.eu>
	<AANLkTi=oHVCoeuz20qkBHTUDEwTEDsN4mFdR8nE+CaNk@mail.gmail.com>
	<20100914021532.9C53E403E6@magilla.sf.frob.com>
	<AANLkTikWqmxob31RjTxu3zwypxJ29KO=zVEko-157iLB@mail.gmail.com>
X-Windows: it could be worse, but it'll take time.
Message-Id: <20100914023129.8ACE9403E6@magilla.sf.frob.com>
Date: Mon, 13 Sep 2010 19:31:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Got it. Then I'll submit this to akpm but I think I don't have your
> Acked-by yet. :-)
> Thanks for the information.

The cosmetic-only version of the generic patches was fine with me,
i.e. where you don't replace put_user with copy_to_user et al.
I don't have a particular say on the various arch code (a few of the arch
maintainers tend to listen to me about this stuff, but it's up to them), so
I didn't respond to those.


Thanks,
Roland
