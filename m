Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab1AQMlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 07:41:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab1AQMlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 07:41:00 -0500
Date: Mon, 17 Jan 2011 10:40:29 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Franck Bui-Huu <fbuihuu@gmail.com>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -perf/perf/core 4/6] perf: Add strfilter for general
	purpose string filter
Message-ID: <20110117124029.GC3902@ghostprotocols.net>
References: <20110113124548.22426.11201.stgit@ltc236.sdl.hitachi.co.jp> <20110113124617.22426.25293.stgit@ltc236.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110113124617.22426.25293.stgit@ltc236.sdl.hitachi.co.jp>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 13, 2011 at 09:46:17PM +0900, Masami Hiramatsu escreveu:
> Add strfilter for general purpose string filter.
> Every filter rules are descrived by glob matching pattern
> and '!' prefix which means Logical NOT.
> A strfilter consists of those filter rules connected
> with '&' and '|'. A set of rules can be folded by using
> '(' and ')'. It also accepts spaces around rules and those

You're not checking strfilter__alloc results, I'm fixing this for you
this time :-)

- Arnaldo
