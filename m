Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab2IHMvL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 08:51:11 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:39929 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab2IHMvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 08:51:07 -0400
X-Greylist: delayed 44321 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Sep 2012 08:51:07 EDT
Date: Sat, 8 Sep 2012 05:50:59 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 05/12] perf diff: Refactor stdio ui data columns output
Message-ID: <20120908125059.GG20401@ghostprotocols.net>
References: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
 <1346946426-13496-6-git-send-email-jolsa@redhat.com>
 <878vcmczjt.fsf@sejong.aot.lge.com>
 <20120908123514.GA3408@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120908123514.GA3408@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Sep 08, 2012 at 02:35:14PM +0200, Jiri Olsa escreveu:
> On Fri, Sep 07, 2012 at 11:55:02AM +0900, Namhyung Kim wrote:
> > Hi, Jiri
> > 
> > On Thu,  6 Sep 2012 17:46:59 +0200, Jiri Olsa wrote:
> > > Currently for any of the data columns (like Overhead/Period..) in
> > > stdio ui, there's separate code to print header/dots/value scattered
> > > along the display code path.
> > >
> > > Adding hists_stdio_column struct to centralize all info needed
> > > to print column header/dots/value.
> > >
> > > This change eases up addition for new columns, which is now mostly
> > > matter only of adding new hists_stdio_column struct.
> > 
> > As you may know, I submitted a similar patchset few days ago for the
> > same reason and it handles TUI/GTK cases as well.  I'm waiting for
> > reviews.
> 
> ok, I'll rebase this to acme/tmp.perf/hpp

well, you can, but that one is buggy and you will not be able to test
'perf diff' at all...

- Arnaldo
