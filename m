Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751145Ab0JRB2t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 21:28:49 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38931 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab0JRB2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 21:28:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: fweisbec <fweisbec@gmail.com>
Subject: Re: 2.6.36-rc5-mmotm0928 BUG while trying to ptrace a process
Cc: kosaki.motohiro@jp.fujitsu.com, Valdis.Kletnieks@vt.edu,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1286372708.2144.183.camel@laptop>
References: <108598.1286357577@localhost> <1286372708.2144.183.camel@laptop>
Message-Id: <20101018102609.3ADF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 18 Oct 2010 10:28:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2010-10-06 at 05:32 -0400, Valdis.Kletnieks@vt.edu wrote:
> > Dell Latitude E6500,  Intel Core2 Duo P8700 CPU.
> > 
> > Have seen this three times now while trying to attach gdb to a hung Firefox
> > process.
> > 
> > [20669.480674] BUG: unable to handle kernel NULL pointer dereference at 0000000000000100
> > [20669.480682] IP: [<ffffffff810b8275>] __reserve_bp_slot+0x56/0x17d
> 
> Known issue I think, Frederic was looking into curing this.
> 
> Frederic, what's the current status of that?

mmotm1014 seems still have this issue. Frederic, can you please tell us
current status if you are tracking this issue?




