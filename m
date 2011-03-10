Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab1CJOJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 09:09:23 -0500
Received: from mx2.netapp.com ([216.240.18.37]:53683 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664Ab1CJOJV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 09:09:21 -0500
X-IronPort-AV: E=Sophos;i="4.62,295,1297065600"; 
   d="scan'208";a="528594923"
Subject: Re: [Bug #30322] BUG in xs_tcp_setup_socket
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Pavel Emelyanov <xemul@parallels.com>, linux-nfs@vger.kernel.org,
        "J. Bruce Fields" <bfields@fieldses.org>,
        David Miller <davem@davemloft.net>
In-Reply-To: <20110309164844.decd835f.akpm@linux-foundation.org>
References: <dtUMITvTCCN.A.uuF.y-3cNB@chimera>
	 <sUKqYsqyJ4N.A.n0F.3-3cNB@chimera>
	 <20110309164844.decd835f.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp Inc
Date: Thu, 10 Mar 2011 09:08:58 -0500
Message-ID: <1299766138.3075.3.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
X-OriginalArrivalTime: 10 Mar 2011 14:09:02.0113 (UTC) FILETIME=[B5295110:01CBDF2C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 16:48 -0800, Andrew Morton wrote: 
> On Sun,  6 Mar 2011 13:40:43 +0100 (CET)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.36 and 2.6.37.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.36 and 2.6.37.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=30322
> > Subject		: BUG in xs_tcp_setup_socket
> > Submitter	: Ben Hutchings <bhutchings@solarflare.com>
> > Date		: 2011-03-01 20:34 (6 days old)
> > Patch		: http://article.gmane.org/gmane.linux.nfs/38949
> > 
> 
> Ben's patch is a no-brainer but it is not yet in mainline or linux-next. 
> I'm not on linux-nfs so I recreated it as below.

It is in linux-next. I've queued it up as part of a bugfix dump to Linus
this weekend.

Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

