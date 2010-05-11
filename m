Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab0EKKl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 06:41:29 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:33978
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750818Ab0EKKl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 06:41:27 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz98dN936eM4015L62a3Lzz1202hzzz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L294CK-02-3JK-02
X-M-MSG: 
Date: Tue, 11 May 2010 12:41:08 +0200
From: Robert Richter <robert.richter@amd.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip] perf probe: Check older elfutils and set NO_DWARF
Message-ID: <20100511104108.GK6450@erda.amd.com>
References: <4BE85C51.704@redhat.com>
 <20100511045953.9913.19485.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100511045953.9913.19485.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.05.10 00:59:53, Masami Hiramatsu wrote:
> Check whether elfutils is older than 0.138 (from which version checking
> routine has been introduced). And if so, set NO_DWARF because it is hard
> to check the API dependency without version checking.

This works for me, now the DWARF_SUPPORT macro is undefined and a
warning is generated:

Makefile:510: No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

