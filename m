Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab2BWBls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 20:41:48 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:54337 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2BWBlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 20:41:46 -0500
X-AuditID: b753bd60-9ea82ba000000655-10-4f45995751de
X-AuditID: b753bd60-9ea82ba000000655-10-4f45995751de
Message-ID: <4F459941.1000006@hitachi.com>
Date: Thu, 23 Feb 2012 10:41:21 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, ananth@in.ibm.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: Re: [tip:perf/core] x86/kprobes: Fix to recover instructions
 on optimized path
References: <20120221083621.11350.4716.stgit@localhost.localdomain> <tip-f5dbbb8e1e055d6f02817a1995993b461910b1b7@git.kernel.org> <20120222162224.GA5256@elte.hu>
In-Reply-To: <20120222162224.GA5256@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/02/23 1:22), Ingo Molnar wrote:
> 
> * tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> Commit-ID:  f5dbbb8e1e055d6f02817a1995993b461910b1b7
>> Gitweb:     http://git.kernel.org/tip/f5dbbb8e1e055d6f02817a1995993b461910b1b7
>> Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> AuthorDate: Tue, 21 Feb 2012 17:36:21 +0900
>> Committer:  Ingo Molnar <mingo@elte.hu>
>> CommitDate: Wed, 22 Feb 2012 11:31:34 +0100
>>
>> x86/kprobes: Fix to recover instructions on optimized path
> 
> Does not build on x86 if CONFIG_OPTPROBES is off:
> 
> arch/x86/kernel/kprobes.c:260:8: error: dereferencing pointer to incomplete type
> arch/x86/kernel/kprobes.c:260:8: error: invalid use of undefined type ‘struct optimized_kprobe’
> arch/x86/kernel/kprobes.c:262:22: error: dereferencing pointer to incomplete type
> arch/x86/kernel/kprobes.c:264:18: error: dereferencing pointer to incomplete type

Oops, should I update this patch or send new diff?

Thank you,



-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
