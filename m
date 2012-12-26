Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169Ab2LZFKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 00:10:46 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50285 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab2LZFKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 00:10:43 -0500
X-AuditID: 9c93016f-b7b54ae000000e9e-a5-50da86d0d6d0
From: Namhyung Kim <namhyung@kernel.org>
To: Stefan Beller <stefanbeller@googlemail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul Mackerras \(supporter\:PERFORMANCE EVENT...\)" 
	<paulus@samba.org>,
        "Ingo Molnar \(supporter\:PERFORMANCE EVENT...\
	,commit_signer\:2\/9\=22%\)" <mingo@redhat.com>,
        "Arnaldo Carvalho de Melo \(supporter\:PERFORMANCE EVENT... \
	,commit_signer\:7\/9\=78%\)" <acme@ghostprotocols.net>,
        "Stephane Eranian \(commit_signer\:2\/9\=22%\)" <eranian@google.com>,
        "Anton Blanchard \(commit_signer\:1\/9\=11%\)" <anton@samba.org>,
        open list <linux-kernel@vger.kernel.org>
Illegal-Object: Syntax error in Cc: addresses found on vger.kernel.org:
	Cc:	"Ingo Molnar \(supporter\:PERFORMANCE EVENT...\ ,commit_signer\:2\/9\=22%\)" <mingo@redhat.com>
			^-missing character after backslash
Subject: Re: Segfault in perf tool
References: <50D77528.6050003@googlemail.com>
Date: Wed, 26 Dec 2012 14:10:40 +0900
In-Reply-To: <50D77528.6050003@googlemail.com> (Stefan Beller's message of
	"Sun, 23 Dec 2012 22:18:32 +0100")
Message-ID: <87zk11s8j3.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

On Sun, 23 Dec 2012 22:18:32 +0100, Stefan Beller wrote:
> Hi,
>
> I get segmentation faults when running one of these commands:
> perf report -g --sort symbol_to
> perf report -g --sort symbol_from
> perf report -g --sort dso_from
> perf report -g --sort dso_to

Those sort keys are only applicable for branch filtered perf.data file
(i.e. recorded with -j or -b option) and should not be used for others.
I'll work on the fix soon.

Thanks,
Namhyung

