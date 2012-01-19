Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab2ASIFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 03:05:35 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55708 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab2ASIFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 03:05:33 -0500
X-AuditID: b753bd60-a0885ba000000655-bf-4f17ceca62d8
X-AuditID: b753bd60-a0885ba000000655-bf-4f17ceca62d8
Message-ID: <4F17CEC3.4000003@hitachi.com>
Date: Thu, 19 Jan 2012 17:05:23 +0900
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v4 1/5] perf-script: unify the expressions indicate
 "unknown"
References: <20120116052146.2485.48349.stgit@linux3> <20120116052210.2485.80894.stgit@linux3> <20120117154902.GA15820@infradead.org> <4F164DDA.1040507@hitachi.com> <4F164EE0.1000507@gmail.com>
In-Reply-To: <4F164EE0.1000507@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/01/18 13:47), David Ahern wrote:
> On 01/17/2012 09:43 PM, Akihiro Nagai wrote:
>> I see. I'm going to fix and resend my patches,
>> e.g. map__print_dsoname(self) =>  map__fprintf_dsoname(map, fp)
>
> If you are going to redo the patch set I have one request: change the
> name of the offset field (currently offs in your patch) to symoff to
> mean offset for the symbol name versus offset in the DSO. It's the
> latter that I use locally, so symoff would allow both to coexist.
OK, I'm going to rename 'offs' to 'symoff'.

Thank you.
>
> Thanks,
>
> David
