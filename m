Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab2HWCCC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 22:02:02 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:38830 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab2HWCB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 22:01:58 -0400
X-AuditID: b753bd60-94360ba000007c38-b7-50358f13443f
X-AuditID: b753bd60-94360ba000007c38-b7-50358f13443f
Message-ID: <50358F13.1030607@hitachi.com>
Date: Thu, 23 Aug 2012 11:01:55 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Amit Shah <amit.shah@redhat.com>,
        Anthony Liguori <anthony@codemonkey.ws>, Arnd Bergmann <arnd@arndb.de>,
        Borislav Petkov <bp@amd64.org>, "Franch Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Ingo Molnar <mingo@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 2/5] trace-cmd: Use tracing directory to count CPUs
References: <20120822084251.17293.69086.stgit@ltc189.sdl.hitachi.co.jp>  <20120822084312.17293.47596.stgit@ltc189.sdl.hitachi.co.jp> <1345642893.5069.31.camel@gandalf.local.home>
In-Reply-To: <1345642893.5069.31.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/08/22 22:41), Steven Rostedt wrote:
> On Wed, 2012-08-22 at 17:43 +0900, Yoshihiro YUNOMAE wrote:
>> From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>>
>> Count debugfs/tracing/per_cpu/cpu* to determine the
>> number of CPUs.
> 
> I'm curious, do you find that sysconf doesn't return the # of CPUs the
> system has?

No, sysconf returns the number of hosts CPUs, not guests.

> I've had boxes where the per_cpu/cpu* had more cpus than the
> box actually holds. But this was a bug in the kernel, not the tool. This
> change log needs to have rational instead of just explaining what the
> patch does.

Ah, I see. Hmm, then this should be enabled by a command line
option or an environment variable.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


