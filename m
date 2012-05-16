Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964806Ab2EPBqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 21:46:24 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47728 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344Ab2EPBqW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 21:46:22 -0400
X-AuditID: 9c93016f-b7cecae000000e00-07-4fb306e9685a
From: Namhyung Kim <namhyung.kim@lge.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        Hyeoncheol Lee <cheol.lee@lge.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [QUESTION] Kprobes as a module?
References: <87zk99zwb8.fsf@sejong.aot.lge.com> <4FB2146E.20101@gmail.com>
	<87vcjxzvtn.fsf@sejong.aot.lge.com> <4FB24991.1040500@hitachi.com>
Date: Wed, 16 May 2012 10:44:26 +0900
In-Reply-To: <4FB24991.1040500@hitachi.com> (Masami Hiramatsu's message of
	"Tue, 15 May 2012 21:18:25 +0900")
Message-ID: <8762bwew79.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 15 May 2012 21:18:25 +0900, Masami Hiramatsu wrote:
> No, actually you can't make it as a module.　There are
> two major reasons.
>  - ftrace depends on the kprobes now.
>  - int3 handling routine is deeply depends on
>    the architecture. This includes text modifying code.
>
> Thus, if you separate the kprobes into module, that means
> you need to expose more ugly interface of self modifying
> for kernel modules.
>

I see.


> (2012/05/15 17:34), Namhyung Kim wrote:
>> Hi,
>> 
>> On Tue, 15 May 2012 16:31:42 +0800, Cong Wang wrote:
>>> On 05/15/2012 04:24 PM, Namhyung Kim wrote:
>>>> Hi,
>>>>
>>>> Probably a dumb question :).
>>>> What prevents the kprobes from being built as a module? We want to use
>>>> the kprobes on our systems, but some guys worried about potential
>>>> security problems. So it'd be great if we can enable/load kprobes as
>>>> needed and then disable/unload after using it. Is it a possible senario?
>
> BTW, I'm not sure what the potential security problems on that?
> kprobes itself can be used only from kernel modules(except ftrace).
> If someone compromises kernel with kernel module, he doesn't need
> kprobes at all. They just can do anything they want. :)
>

Nevermind, it seems they just worried about what they don't know
exactly. Anyway, thanks for your answer.

Namhyung
