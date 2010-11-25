Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab0KYHET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 02:04:19 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:51998 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab0KYHES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 02:04:18 -0500
Message-ID: <4CEE0A66.6000409@dcl.info.waseda.ac.jp>
Date: Thu, 25 Nov 2010 16:04:06 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, h.mitake@gmail.com,
        Ma Ling <ling.ma@intel.com>, Zhao Yakui <yakui.zhao@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] perf bench: print both of prefaulted and no prefaulted
 results
References: <4CDD56E3.5030303@dcl.info.waseda.ac.jp> <1289574158-6959-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <20101118075816.GG32621@elte.hu>
In-Reply-To: <20101118075816.GG32621@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Really sorry for my late reply..

On 11/18/10 16:58, Ingo Molnar wrote:
 >
 > * Hitoshi Mitake<mitake@dcl.info.waseda.ac.jp>  wrote:
 >
 >> After applying this patch, perf bench mem memcpy prints
 >> both of prefualted and without prefaulted score of memcpy().
 >>
 >> New options --no-prefault and --only-prefault are added
 >> for printing single result, mainly for scripting usage.
 >
 > Ok. Mind resending the whole series once all review feedback has been 
incorporated?
 >

OK, I'll send the patch series for prefaulting and
porting memcpy_64.S to perf bench later.
This series do some dirty things especially in Makefile
of perf and defining ENTRY(). So I'd like to hear your comment.
Could you review these?

And I have another problem. I cannot see the name of
memcpy based on rep prefix because the symbol of it is ".Lmemcpy_c".
It seems that the symbol name start from "." cannot be seen
from other object files. So I have to seek the way to
find the name of rep memcpy...

Thanks,
	Hitoshi
