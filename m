Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab0ERCt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 22:49:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149Ab0ERCt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 22:49:57 -0400
Message-ID: <4BF2003D.3080107@redhat.com>
Date: Mon, 17 May 2010 22:49:33 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
CC: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 0/4] perf-probe updates: string support, etc.
References: <20100518024919.25275.58125.stgit@localhost6.localdomain6>
In-Reply-To: <20100518024919.25275.58125.stgit@localhost6.localdomain6>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> 
> Hi,
> 
> Here is a series of patches which improves perf probe to
> add below features.

Oops, I've found some bugs. I'll fix it and send again.

Thank you,

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
