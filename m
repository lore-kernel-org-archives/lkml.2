Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab2D2UHe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 16:07:34 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58333 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab2D2UHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 16:07:33 -0400
MIME-Version: 1.0
In-Reply-To: <CABPqkBRcjGuUhaSUnC7GeftV16_+T2L=C56imJyRckLuPJYWuA@mail.gmail.com>
References: <CAEbykaXUy7HEyW7mBaTNmB94NwyjuJBbA1R-H49Jjk5M-iL_fw@mail.gmail.com>
	<1332409996.18960.511.camel@twins>
	<CAEbykaUbkgCEcufTx4ZBSdqwrifVbV384Ru4xTyF7BXYtJ85Zg@mail.gmail.com>
	<1332765676.16159.108.camel@twins>
	<CABPqkBRcjGuUhaSUnC7GeftV16_+T2L=C56imJyRckLuPJYWuA@mail.gmail.com>
Date: Sun, 29 Apr 2012 23:07:32 +0300
Message-ID: <CAEbykaVeonifGfk-ju9+17DG0ah7zCOv6SGwQ_rnD=K7Kpyh1Q@mail.gmail.com>
Subject: Re: [PATCH] perf: Fix RCU dereference check in perf_event_comm
From: Ari Savolainen <ari.m.savolainen@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Did that warning occur while you were NOT measuring cgroup events?
>

The warning occurs every time I execute perf record for the first time
after rebooting (e.g. perf record sleep 1).

Ari
