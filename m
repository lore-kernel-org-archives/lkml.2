Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab0DNX3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 19:29:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201Ab0DNX3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 19:29:17 -0400
Date: Wed, 14 Apr 2010 20:28:55 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 0/6] perf-probe bugfixes
Message-ID: <20100414232855.GK25649@ghostprotocols.net>
References: <20100414223921.14630.62353.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100414223921.14630.62353.stgit@localhost6.localdomain6>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Apr 14, 2010 at 06:39:21PM -0400, Masami Hiramatsu escreveu:
> Hi Arnaldo,
> 
> (Sorry, I've fixed to signed-off-by and send it again)
> Could you pull these patches into your tree too?
> These fixes several bugs on perf probe.
> 
> Thank you,

Sure, I just applied your previous series and will now review this new
one and merge it after that.
