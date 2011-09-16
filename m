Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab1IPVUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 17:20:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48387 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab1IPVUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 17:20:40 -0400
Message-ID: <4E73BDA4.1050007@suse.cz>
Date: Fri, 16 Sep 2011 23:20:36 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110912 Thunderbird/7.0
MIME-Version: 1.0
CC: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: ia64 build broken on CONFIG_DEBUG_STACK_USAGE
References: <4E5204E3.7070107@suse.cz>
In-Reply-To: <4E5204E3.7070107@suse.cz>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2011 09:27 AM, Jiri Slaby wrote:
> Hi,
> 
> when CONFIG_DEBUG_STACK_USAGE is selected, I get these errors:
>   CC      arch/ia64/kernel/asm-offsets.s
> In file included from arch/ia64/kernel/asm-offsets.c:9:
> include/linux/sched.h: In function ‘stack_not_used’:
> include/linux/sched.h:2419: error: ‘IA64_TASK_SIZE’ undeclared (first
> use in this function)
> include/linux/sched.h:2419: error: (Each undeclared identifier is
> reported only once
> include/linux/sched.h:2419: error: for each function it appears in.)
> include/linux/sched.h:2419: error: ‘IA64_THREAD_INFO_SIZE’ undeclared
> (first use in this function)
> make[1]: *** [arch/ia64/kernel/asm-offsets.s] Error 1
> make: *** [prepare0] Error 2

Hi again. This is still an issue in the current Linus tree.

Do you have any idea how to fix it?

thanks,
-- 
js
suse labs
