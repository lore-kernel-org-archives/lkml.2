Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab2IHMfq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 08:35:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab2IHMfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 08:35:45 -0400
Date: Sat, 8 Sep 2012 14:35:14 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 05/12] perf diff: Refactor stdio ui data columns output
Message-ID: <20120908123514.GA3408@krava.brq.redhat.com>
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

ok, I'll rebase this to acme/tmp.perf/hpp

jirka
