Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab0GLROt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 13:14:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596Ab0GLROs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 13:14:48 -0400
Date: Mon, 12 Jul 2010 14:14:22 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Ian Munsie <imunsie@au.ibm.com>,
        Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH] perf: Add DWARF register lookup for SH
Message-ID: <20100712171422.GA4668@ghostprotocols.net>
References: <e55812819ad18c2ceca5651ac7698a2af46180d7.1278774279.git.matt@console-pimps.org> <4C3AD8F9.5070703@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3AD8F9.5070703@hitachi.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jul 12, 2010 at 05:57:29PM +0900, Masami Hiramatsu escreveu:
> Matt Fleming wrote:
> > Implement get_arch_regstr() for SH so that, given a DWARF register
> > number, the corresponding symbolic name of that register can be looked
> > up.
> 
> KPROBE_EVENT has already been supported on the latest linux-sh,
> so this should be work on that.
> 
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks, applying it then,

- Arnaldo
