Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761389Ab0HFOK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 10:10:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756861Ab0HFOKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 10:10:55 -0400
Date: Fri, 6 Aug 2010 11:10:29 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH 1/2] [BUGFIX] perf probe: Fix to copy the type for raw
	parameters
Message-ID: <20100806141029.GB17509@ghostprotocols.net>
References: <4C577AD8.50808@hitachi.com> <4C5BB727.80905@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C5BB727.80905@hitachi.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Aug 06, 2010 at 04:17:59PM +0900, Masami Hiramatsu escreveu:
> Masami Hiramatsu wrote:
> > Copy type field if it is for raw parameters.
> > Without this fix, perf probe drops the type if user passes it
> > for raw parameters (e.g. %ax:u32 will be converted to %ax).
> Hi Arnaldo,
> 
> Could you pick these patches?

Sure.
 
- Arnaldo
