Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab2EOIg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 04:36:26 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:56915 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757237Ab2EOIgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 04:36:24 -0400
X-AuditID: 9c93016f-b7cecae000000e00-78-4fb215843a53
From: Namhyung Kim <namhyung.kim@lge.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, Hyeoncheol Lee <cheol.lee@lge.com>
Subject: Re: [QUESTION] Kprobes as a module?
References: <87zk99zwb8.fsf@sejong.aot.lge.com> <4FB2146E.20101@gmail.com>
Date: Tue, 15 May 2012 17:34:44 +0900
In-Reply-To: <4FB2146E.20101@gmail.com> (Cong Wang's message of "Tue, 15 May
	2012 16:31:42 +0800")
Message-ID: <87vcjxzvtn.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 15 May 2012 16:31:42 +0800, Cong Wang wrote:
> On 05/15/2012 04:24 PM, Namhyung Kim wrote:
>> Hi,
>>
>> Probably a dumb question :).
>> What prevents the kprobes from being built as a module? We want to use
>> the kprobes on our systems, but some guys worried about potential
>> security problems. So it'd be great if we can enable/load kprobes as
>> needed and then disable/unload after using it. Is it a possible senario?
>>
>
> Kconfig prevents that:
>
> config KPROBES
>         bool "Kprobes"
>         depends on MODULES
>         depends on HAVE_KPROBES
>         select KALLSYMS
>
>
> so you can have either CONFIG_KPROBES=y or CONFIG_KPROBES=n, but not =m.

Sorry for an inaccurate question, my point was "Can I change it from
'bool' to 'tristate'"?

Thanks,
Namhyung
