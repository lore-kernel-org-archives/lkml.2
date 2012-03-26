Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878Ab2CZPgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 11:36:45 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59074 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932722Ab2CZPgm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 11:36:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120325.150452.2130364052890102881.davem@davemloft.net>
References: <1332698348-2253-1-git-send-email-consul.kautuk@gmail.com>
	<20120325.150452.2130364052890102881.davem@davemloft.net>
Date: Mon, 26 Mar 2012 11:36:42 -0400
Message-ID: <CAFPAmTQLVSnujH+yWh+oePLvg1BcaW1LuP3tOWpYhsSRmdQ5JQ@mail.gmail.com>
Subject: Re: [PATCH 20/20 v2] sparc/mm/fault_64.c: Port OOM changes to do_sparc64_fault
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
> Date: Sun, 25 Mar 2012 13:59:08 -0400
>
>> +                     perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ,
>> +                                     1, regs, address);
>
> Improperly indented still.
>
>> +                     perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN,
>> +                                     1, regs, address);
>
> Likewise.

I didn't understand what you were saying as I use gmaiil so I could not "see"
what you meant exactly.
I have sent a v3 for this.
