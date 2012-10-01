Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab2JACZo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 22:25:44 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:34681 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab2JACZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 22:25:43 -0400
X-AuditID: b753bd60-99054ba000002f78-83-5068ff2482eb
X-AuditID: b753bd60-99054ba000002f78-83-5068ff2482eb
Message-ID: <5068FF21.1080601@hitachi.com>
Date: Mon, 01 Oct 2012 11:25:37 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [PATCH -tip  0/3] Move kprobes files under the kprobes
 directory
References: <20120928081509.3560.8860.stgit@ltc138.sdl.hitachi.co.jp> <1348835692.22822.97.camel@gandalf.local.home>
In-Reply-To: <1348835692.22822.97.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/09/28 21:34), Steven Rostedt wrote:
> On Fri, 2012-09-28 at 17:15 +0900, Masami Hiramatsu wrote:
>> Hi,
>>
>> Here are a series of patches to split ftrace-based kprobe part
>> from arch/x86/kernel/kprobes.c and to move kprobes related
>> files under arch/x86/kernel/kprobes/, according to Ingo's
>> suggestion.
>> https://lkml.org/lkml/2012/9/20/122
>>
> 
> Hi Masami,
> 
> Thanks for sending this. As it is getting very close to the merge
> window, do you feel that his is good enough to push for 3.7, or do you
> think we should hold off till 3.8, and let it brew a while?

Thank you for asking, this is just a kind of cleanup, so I think stable
enough for 3.7. At least, it is better to push this into tip tree
for future works. :)

Thank you again,

-- 
Masami HIRAMATSU
Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


