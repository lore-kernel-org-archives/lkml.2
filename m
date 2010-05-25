Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab0EYE6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 00:58:09 -0400
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:40785 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab0EYE6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 00:58:08 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: proc_dointvec() and write
To: Cong Wang <amwang@redhat.com>
Cc: opurdila@ixiacom.com, davem@davemloft.net, linux-kernel@vger.kernel.org
In-Reply-To: <4BFB56F1.1080200@redhat.com>
References: <306.1274711539@jrobl> <4BFB56F1.1080200@redhat.com>
Date: Tue, 25 May 2010 13:57:40 +0900
Message-ID: <11729.1274763460@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cong Wang:
> Hmm, odd, I tested other proc files, I see no problem.
> I am wondering why /proc/sys/kernel/printk is special here.

The condition is,
- the entry has multiple values, .maxlen = N * sizeof(foo)
- the entry is writable, .mode = 0644 (or something)

In sysctl.c, only "printk" and "acct" match.


J. R. Okajima
