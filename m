Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab2IYNJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 09:09:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55754 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab2IYNJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 09:09:06 -0400
Subject: Re: [PATCH v2 3/4] perf annotate: configure objdump path at
 compile time
From: Namhyung Kim <namhyung@kernel.org>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Irina Tirdea <irina.tirdea@intel.com>
In-Reply-To: <1348428446-28245-4-git-send-email-irina.tirdea@gmail.com>
References: <1348428446-28245-1-git-send-email-irina.tirdea@gmail.com>
	 <1348428446-28245-4-git-send-email-irina.tirdea@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Sep 2012 22:08:59 +0900
Message-ID: <1348578539.1877.40.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Irina,

2012-09-23 (일), 22:27 +0300, Irina Tirdea:
> From: Irina Tirdea <irina.tirdea@intel.com>
> 
> The default name for objdump is "objdump". For cross-compiling the name of
> objdump will be different (e.g. arm-eabi-objdump in Android).
> 
> Set the default objdump name in the Makefile with DEFAULT_OBJDUMP_PATH.

I thought about it twice and confused.

For cross-compiling, the resulting perf binary will run on target - say
Android - but the toolchain runs on host, right?  So with this change
the cross-built perf will try to find the arm-eabi-objdump on Android.
Is it an intended behavior?  Is there an arm-eabi-objdump on Android?

Thanks,
Namhyung


