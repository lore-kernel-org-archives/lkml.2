Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab2FKV7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 17:59:19 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:37818 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab2FKV7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 17:59:18 -0400
Date: Mon, 11 Jun 2012 18:59:12 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Andi Kleen <ak@linux.intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: Does perf inject preserve call chain data?
Message-ID: <20120611215912.GA3897@infradead.org>
References: <1337712585.3796.186.camel@schen9-DESK>
 <4FBC0C10.8010801@gmail.com>
 <20120608143843.GA9954@infradead.org>
 <1339173896.3796.230.camel@schen9-DESK>
 <4FD232B7.7080905@gmail.com>
 <1339175828.3796.232.camel@schen9-DESK>
 <20120608195215.GO28225@tassilo.jf.intel.com>
 <20120609160547.GB9954@infradead.org>
 <4FD63C52.4090003@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD63C52.4090003@linux.intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jun 11, 2012 at 11:43:30AM -0700, Andi Kleen escreveu:
> ># perf top -a -G sleep 5
> >
> >Where it would figure out that since a workload was specified, it should
> >just not be refreshing the screen every N seconds but wait till the
> >workload to finish and then present the results, without setting up any
> >perf.data files.
> 
> But top does not generate email'able ASCII format like perf report
> does, doesn't it?

http://git.kernel.org/?p=linux/kernel/git/acme/linux.git;a=commit;h=a78e5b82e99d8d284afc012ef015ef3332153aaf

perf hists browser: Implement printing snapshots to files

To avoid having to resort to --stdio, that expands everything, instead
allow the user to go on expanding the relevant callchains and then press
'P' to print that view.

As the hists browser is used for both static (report) and dynamic (top)
views, it prints to a 'perf.hists.N' sequence, i.e. multiple snapshots
can be taken in report and top.

</>

On a v3.6 kernel near you, together with:

http://git.kernel.org/?p=linux/kernel/git/acme/linux.git;a=commit;h=bd622d64e4bb0d10e8f0c2df4de9303ee415ffae

:-)

- Arnaldo
