Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812Ab2CZPf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 11:35:58 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37060 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932614Ab2CZPf4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 11:35:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120325.150422.2000357641354896689.davem@davemloft.net>
References: <1332698315-2218-1-git-send-email-consul.kautuk@gmail.com>
	<20120325.150422.2000357641354896689.davem@davemloft.net>
Date: Mon, 26 Mar 2012 11:35:56 -0400
Message-ID: <CAFPAmTT6pcjzi8WsM+r3izreGiuNaK5c4NkDav=6+wFj55QF4Q@mail.gmail.com>
Subject: Re: [PATCH 19/20 v2] sparc/mm/fault_32.c: Port OOM changes to do_sparc_fault
From: Kautuk Consul <consul.kautuk@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: paul.gortmaker@windriver.com, mingo@elte.hu, joe@perches.com,
        a.p.zijlstra@chello.nl, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2012 at 3:04 PM, David Miller <davem@davemloft.net> wrote:
> From: Kautuk Consul <consul.kautuk@gmail.com>
> Date: Sun, 25 Mar 2012 13:58:35 -0400
>
>> +     unsigned int flags = (FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
>> +                                     (write ? FAULT_FLAG_WRITE : 0));
>
> Still indented wrong, it should be:
>
>        unsigned int flags = (FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
>                              (write ? FAULT_FLAG_WRITE : 0));
>
> The second line must have the openning parenthesis line up with
> the column after the openning parenthesis on the first line.  Do
> not use only tabs to indent this stuff, line it up properly.
>
> You need to use tabs and spaces to line it up.  Use something like
> emacs's C-mode to help you if you can't do it right by hand.
>
>> +                     perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ,
>> +                                     1, regs, address);
>
> Still wrong, for the same exact reason.
>
> I went out of my way to reply to your private email (which I usually
> ignore, you should never email developers privately) and you didn't
> even listen to the feedback I gave you.


I use gmail which did not show me the indentation which you wanted.
I understand what you said now and have sent a v3 for this.
