Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934097Ab2FHTwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 15:52:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:36586 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933436Ab2FHTwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 15:52:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163041118"
Date: Fri, 8 Jun 2012 12:52:15 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: Does perf inject preserve call chain data?
Message-ID: <20120608195215.GO28225@tassilo.jf.intel.com>
References: <1337712585.3796.186.camel@schen9-DESK>
 <4FBC0C10.8010801@gmail.com>
 <20120608143843.GA9954@infradead.org>
 <1339173896.3796.230.camel@schen9-DESK>
 <4FD232B7.7080905@gmail.com>
 <1339175828.3796.232.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339175828.3796.232.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >
> > > # ./perf record -a -g -o - sleep 5 |perf inject -v -b  | perf report -g  -i -

Since this is a common pattern with files, but files are often
slow and too big, it would be nice if perf had a 
standard alias that started this pipeline.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
