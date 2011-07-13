Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab1GMVUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 17:20:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:50559 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab1GMVUx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 17:20:53 -0400
Subject: Re: [PATCH] perf:  Add drop monitor script
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <20110713192316.GA12498@hmsreliant.think-freely.org>
References: <1309801217-22450-1-git-send-email-nhorman@tuxdriver.com>
	 <20110713192316.GA12498@hmsreliant.think-freely.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 13 Jul 2011 23:20:42 +0200
Message-ID: <1310592042.2586.43.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-13 at 15:23 -0400, Neil Horman wrote:
> On Mon, Jul 04, 2011 at 01:40:17PM -0400, Neil Horman wrote:
> > A while back I created the dropmonitor protocol, which allowed users to get
> > reports of dropped frames communicated to them via a netlink socket.  While
> > useful, several people have now asked that I integrate the ability to do drop
> > monitoring with perf, so they don't have to run additional tools.  This patch
> > adds a drop monitor script to the perf suite, and provides the same output that
> > the netlink socket does.
> > 
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > CC: Paul Mackerras <paulus@samba.org>
> > CC: Ingo Molnar <mingo@elte.hu>
> > CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Ping guys, any feedback on this?

I don't speak snake, nor really condone snake speak. You'll have to wait
until acme is back from holidays.
