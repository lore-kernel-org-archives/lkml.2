Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966472Ab2EPCwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 22:52:04 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:46715 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932873Ab2EPCwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 22:52:01 -0400
X-AuditID: 9c930179-b7bb9ae000000ea5-aa-4fb3164b1ee9
From: Namhyung Kim <namhyung.kim@lge.com>
To: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, acme@redhat.com
Subject: Re: [PATCH v2 0/5] perf tools: add meta-data header support in pipe mode
References: <1337081295-10303-1-git-send-email-eranian@google.com>
	<87ehqkewom.fsf@sejong.aot.lge.com> <4FB30B52.7080104@gmail.com>
	<87txzgdfeo.fsf@sejong.aot.lge.com> <4FB3130D.7040308@gmail.com>
Date: Wed, 16 May 2012 11:50:05 +0900
In-Reply-To: <4FB3130D.7040308@gmail.com> (David Ahern's message of "Tue, 15
	May 2012 20:38:05 -0600")
Message-ID: <87pqa4dele.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 15 May 2012 20:38:05 -0600, David Ahern wrote:
> See tools/perf/util/header.{ch}
> Runtime example:
>
> perf script -i /tmp/perf.data -I
>
> # ========
> # captured on: Tue May 15 20:22:15 2012
> # ========
> #
> # hostname : nxos-vdc-dev3
> # os release : 3.4.0-rc7+
> # perf version : 3.4.rc4.137.g978da3.dirty
> # arch : x86_64
> # nrcpus online : 16
> # nrcpus avail : 16
> # cpudesc : Intel(R) Xeon(R) CPU E5540 @ 2.53GHz
> # cpuid : GenuineIntel,6,26,5
> # total memory : 24680324 kB
> # cmdline : /tmp/pbuild/perf record -fo /tmp/perf.data -- /tmp/noploop
>
> ...
>
> 'perf report --stdio' also shows it. It gets lost in the TUI.
>

Yeah, I know. What I mean is keeping the info in memory after parsing a 
perf.data file so that it can be used for displaying it on a dialog in
perf report TUI (on demand) or checking arch before annotation or ...

Thanks,
Namhyung
