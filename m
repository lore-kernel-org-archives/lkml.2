Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab0DLRtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 13:49:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab0DLRtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 13:49:35 -0400
Date: Mon, 12 Apr 2010 14:49:14 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip v3 00/10] perf-probe updates - data-structure
	support improvements, etc.
Message-ID: <20100412174914.GD6750@ghostprotocols.net>
References: <20100412171646.3790.64715.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100412171646.3790.64715.stgit@localhost6.localdomain6>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Apr 12, 2010 at 01:16:46PM -0400, Masami Hiramatsu escreveu:
> Hi Ingo and Arnaldo,
> 
> Here are several updates of perf-probe. This series improves
> data structure accessing. In this version, I added 'removing x*()'
> patches.

Ingo, I'm ok with this series, do you want me to pull them or will you?

- Arnaldo
