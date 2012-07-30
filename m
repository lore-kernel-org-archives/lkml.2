Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab2G3RYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:24:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487Ab2G3RY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:24:29 -0400
Date: Mon, 30 Jul 2012 14:23:59 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Subject: Re: [PATCH 1/7] perf: Unified API to record selective sets of arch
 registers
Message-ID: <20120730172358.GA1004@infradead.org>
References: <1343391834-10851-1-git-send-email-jolsa@redhat.com>
 <1343391834-10851-2-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1343391834-10851-2-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jul 27, 2012 at 02:23:42PM +0200, Jiri Olsa escreveu:
> This brings a new API to help the selective dump of registers on
> event sampling, and its implementation for x86 arch.

  CC      arch/x86/kernel/perf_regs.o
/home/git/linux/arch/x86/kernel/perf_regs.c: In function
‘perf_reg_validate’:
/home/git/linux/arch/x86/kernel/perf_regs.c:83: error: ‘EINVAL’
undeclared (first use in this function)
/home/git/linux/arch/x86/kernel/perf_regs.c:83: error: (Each undeclared
identifier is reported only once
/home/git/linux/arch/x86/kernel/perf_regs.c:83: error: for each function
it appears in.)

- Arnaldo
