Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab0EKINZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 04:13:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756167Ab0EKINT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 04:13:19 -0400
Subject: Re: [PATCH -tip] perf probe: Don't compile CFI related code if
 elfutils is old
From: Mark Wielaard <mjw@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
       Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       Roland McGrath <roland@redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
In-Reply-To: <4BE85C51.704@redhat.com>
References: <20100510171207.26029.97604.stgit@localhost6.localdomain6>
	 <20100510172854.GD30926@ghostprotocols.net>
	 <20100510183654.GH6450@erda.amd.com> <4BE8571E.4020403@redhat.com>
	 <20100510191501.GC19192@ghostprotocols.net>  <4BE85C51.704@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 10:12:56 +0200
Message-ID: <1273565576.2660.17.camel@hermans.wildebeest.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 15:19 -0400, Masami Hiramatsu wrote:
> Hm, I'd like to add just '#ifndef _ELFUTILS_PREREQ;#error;#endif' to
> NO_DWARF checking in Makefile, because it's easier to expand to another
> API dependency.

You might want to check systemtap/dwarf-wrappers.h which handles missing
_ELFUTILS_PREREQ, so you can use it as if it is always defined. That
said, 0.138 is pretty old (latest is 0.147), so just requiring something
fresh might not be a bad thing.

Cheers,

Mark

