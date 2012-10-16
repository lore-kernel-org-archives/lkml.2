Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab2JPP1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 11:27:05 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:36126 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab2JPP1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 11:27:03 -0400
Date: Tue, 16 Oct 2012 08:26:57 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: Re: [PATCH v4 5/6] perf tools: Try to find cross-built addr2line path
Message-ID: <20121016152657.GF6807@ghostprotocols.net>
References: <1350344020-8071-1-git-send-email-irina.tirdea@gmail.com>
 <1350344020-8071-6-git-send-email-irina.tirdea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350344020-8071-6-git-send-email-irina.tirdea@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 16, 2012 at 02:33:39AM +0300, Irina Tirdea escreveu:
> From: Irina Tirdea <irina.tirdea@intel.com>
> 
> As we have architecture information of saved perf.data file, we can
> also try to find cross-built addr2line path. The predefined triplets
> include support for Android (arm, x86 and mips architectures).

This one is all right, but depends on the previous one, introducing the
lookup routines.

- Arnaldo
