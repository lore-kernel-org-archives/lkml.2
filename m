Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab2EXI4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 04:56:13 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51784 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab2EXI4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 04:56:10 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-76-4fbdf7a79e4b
From: Namhyung Kim <namhyung.kim@lge.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf, x86: Make cycles:p working on SNB
References: <1337828525-1789-1-git-send-email-namhyung.kim@lge.com>
	<1337844471.9783.48.camel@laptop>
Date: Thu, 24 May 2012 17:53:47 +0900
In-Reply-To: <1337844471.9783.48.camel@laptop> (Peter Zijlstra's message of
	"Thu, 24 May 2012 09:27:51 +0200")
Message-ID: <87wr42q7s4.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter

On Thu, 24 May 2012 09:27:51 +0200, Peter Zijlstra wrote:
> Also I'm thinking you're using SNB-EP (you didn't say) since regular SNB
> has PEBS disabled as per (6a600a8b).
>

I don't actually have an idea whether it's a SNB-EP or regular
one. ;-p Is Model 45 a SNB-EP?

namhyung@sejong:perf$ head /proc/cpuinfo 
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 45
model name	: Intel(R) Core(TM) i7-3930K CPU @ 3.20GHz
stepping	: 7
microcode	: 0x704
cpu MHz		: 1200.000
cache size	: 12288 KB
physical id	: 0


Thanks,
Namhyung
