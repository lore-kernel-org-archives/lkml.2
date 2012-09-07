Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602Ab2IGJU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 05:20:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116Ab2IGJU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 05:20:57 -0400
Date: Fri, 7 Sep 2012 11:20:09 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 05/12] perf diff: Refactor stdio ui data columns output
Message-ID: <20120907092009.GB2755@krava.brq.redhat.com>
References: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
 <1346946426-13496-6-git-send-email-jolsa@redhat.com>
 <878vcmczjt.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878vcmczjt.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 11:55:02AM +0900, Namhyung Kim wrote:
> Hi, Jiri
> 
> On Thu,  6 Sep 2012 17:46:59 +0200, Jiri Olsa wrote:
> > Currently for any of the data columns (like Overhead/Period..) in
> > stdio ui, there's separate code to print header/dots/value scattered
> > along the display code path.
> >
> > Adding hists_stdio_column struct to centralize all info needed
> > to print column header/dots/value.
> >
> > This change eases up addition for new columns, which is now mostly
> > matter only of adding new hists_stdio_column struct.
> 
> As you may know, I submitted a similar patchset few days ago for the
> same reason and it handles TUI/GTK cases as well.  I'm waiting for
> reviews.

I must have missed it.. I'll check ;)

jirka
