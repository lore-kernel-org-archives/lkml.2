Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab2JHVEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 17:04:51 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:57966 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab2JHVEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 17:04:46 -0400
Date: Mon, 8 Oct 2012 14:04:40 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: Re: [PATCH v3 7/8] perf tools: configure addr2line for
 cross-compiling
Message-ID: <20121008210440.GJ2631@ghostprotocols.net>
References: <1349678613-7045-1-git-send-email-irina.tirdea@gmail.com>
 <1349678613-7045-8-git-send-email-irina.tirdea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349678613-7045-8-git-send-email-irina.tirdea@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 08, 2012 at 09:43:32AM +0300, Irina Tirdea escreveu:
> From: Irina Tirdea <irina.tirdea@intel.com>
> 
> When analyzing data recorded on a target with a different architecture than
> the host, we must use addr2line from the toolchain for that architecture.
> Add a command line option to set addr2line at runtime.
> 
> As we have architecture information of saved perf.data file, we can
> also try to find cross-built addr2line path. The predefined triplets include
> support for Android (arm, x86 and mips architectures).

Comments made for the objdump patch applies here.

Also there are two patches here, no? One adding --addr2line and the
other trying to find it automatically according the perf_session_env
info in the perf.data header.

- Arnaldo
