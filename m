Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab0LJEsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 23:48:05 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:37228 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220Ab0LJEsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 23:48:02 -0500
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        "tom.leiming" <tom.leiming@gmail.com>
Subject: Re: [PATCH 3/3] perf, powerpc: Allow perf test to handle PowerPC symbol naming
From: Ian Munsie <imunsie@au1.ibm.com>
To: Paul Mackerras <paulus@samba.org>
In-reply-to: <1290658375-10342-3-git-send-email-imunsie@au1.ibm.com>
References: <1290658375-10342-1-git-send-email-imunsie@au1.ibm.com> <1290658375-10342-3-git-send-email-imunsie@au1.ibm.com>
Date: Fri, 10 Dec 2010 15:47:54 +1100
Message-Id: <1291956070-sup-549@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Can you take a look at this patch and ACK (or NACK) it and push it to
Ingo?  The two other patches in this series are already in
tip/perf/core, we're just missing this one.

Cheers,
-Ian

Excerpts from Ian Munsie's message of Thu Nov 25 15:12:55 +1100 2010:
> From: Ian Munsie <imunsie@au1.ibm.com>
> 
> The PowerPC ABI prefixes symbol names with periods, which causes perf
> test to fail when it compares the symbol from the vmlinux file with the
> symbol names from kallsyms. This patch adds the infrastructure to allow
> archs to override how symbol names are compared and implements the
> PowerPC function to disregard any prefixed periods, allowing perf test
> to pass.
