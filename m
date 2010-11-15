Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab0KOAyU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 19:54:20 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35168 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab0KOAyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 19:54:18 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Revert oom rewrite series
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ying Han <yinghan@google.com>, Bodo Eggert <7eggert@web.de>,
        Mandeep Singh Baines <msb@google.com>,
        "Figo.zhang" <figo1802@gmail.com>
In-Reply-To: <AANLkTikSq-qC28uurd17RGup92Kao7enCiGJkDnJG+94@mail.gmail.com>
References: <20101114133543.E00A.A69D9226@jp.fujitsu.com> <AANLkTikSq-qC28uurd17RGup92Kao7enCiGJkDnJG+94@mail.gmail.com>
Message-Id: <20101115093410.BEFD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 15 Nov 2010 09:54:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2010/11/13 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:
> >
> > Please apply this. this patch revert commits of oom changes since v2.6.35.
> 
> I'm not getting involved in this whole flame-war. You need to convince
> Andrew, who has been the person everything went through.

I wonder why he deep silence. But, _I_ strongly don't want to ignore bug report and
userland complain. I hope to fix any bug as far as my development time is allowed.



