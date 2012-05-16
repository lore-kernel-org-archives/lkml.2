Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab2EPPDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:03:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356Ab2EPPDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:03:45 -0400
Date: Wed, 16 May 2012 12:03:25 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu
Subject: Re: [PATCH v2 0/5] perf tools: add meta-data header support in pipe
 mode
Message-ID: <20120516150325.GA24946@infradead.org>
References: <1337081295-10303-1-git-send-email-eranian@google.com>
 <87ehqkewom.fsf@sejong.aot.lge.com>
 <4FB30B52.7080104@gmail.com>
 <87txzgdfeo.fsf@sejong.aot.lge.com>
 <4FB3130D.7040308@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB3130D.7040308@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, May 15, 2012 at 08:38:05PM -0600, David Ahern escreveu:
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

Yeah, we need to add a splash screen with this info when the TUI starts
and also ad a hotkey to show it at anytime.

- Arnaldo
