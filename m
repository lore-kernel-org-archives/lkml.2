Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab2IYI17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 04:27:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:29074 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967Ab2IYI16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 04:27:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,479,1344236400"; 
   d="scan'208";a="226363293"
Date: Tue, 25 Sep 2012 16:21:40 +0800
From: Feng Tang <feng.tang@intel.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: <acme@redhat.com>, <mingo@elte.hu>, <a.p.zijlstra@chello.nl>,
        <andi@firstfloor.org>, <dsahern@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 7/9] perf header: Add check_perf_magic() func
Message-ID: <20120925162140.4ecf3d72@feng-i7>
In-Reply-To: <87haqmyhws.fsf@sejong.aot.lge.com>
References: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
	<1348500251-9937-8-git-send-email-feng.tang@intel.com>
	<87haqmyhws.fsf@sejong.aot.lge.com>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2012 11:07:15 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> On Mon, 24 Sep 2012 23:24:09 +0800, Feng Tang wrote:
> [snip]
> > +/* Return 0 if matched */
> > +int check_perf_magic(u64 magic)
> > +{
> > +	if (!memcmp(&magic, __perf_magic1, sizeof(magic))
> > +		|| magic == __perf_magic2
> > +		|| magic == __perf_magic2_sw)
> > +		return 0;
> > +
> > +	return -1;
> > +}
> 
> Just an idea.  How about returning version number instead of 0 so that
> it can be used elsewhere those check is needed and possibly wants to
> know the version number also?

Sounds ok to me, I can add that if nobody has objection.

Thanks,
Feng
