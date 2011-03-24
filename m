Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867Ab1CXGnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 02:43:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:64170 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932228Ab1CXGnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 02:43:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,235,1299484800"; 
   d="scan'208";a="670887039"
Subject: Re: [performance bug] kernel building regression on 64 LCPUs
 machine
From: "Alex,Shi" <alex.shi@intel.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Corrado Zoccolo <czoccolo@gmail.com>,
        "Li, Shaohua" <shaohua.li@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
In-Reply-To: <x49r59zrqu9.fsf@segfault.boston.devel.redhat.com>
References: <AANLkTinAeQMy-OoYYpbYeX=EjZ_-uT=67Ktk1PbE=A7_@mail.gmail.com>
	 <x49hbbmpqbo.fsf@segfault.boston.devel.redhat.com>
	 <20110302094246.GA7496@quack.suse.cz>
	 <x491v2p4i0u.fsf@segfault.boston.devel.redhat.com>
	 <20110302211748.GF7496@quack.suse.cz>
	 <x49lj0x0zve.fsf@segfault.boston.devel.redhat.com>
	 <20110304153248.GC2649@quack.suse.cz>
	 <x49d3m6j35j.fsf@segfault.boston.devel.redhat.com>
	 <x491v2mivv6.fsf@segfault.boston.devel.redhat.com>
	 <1300779499.30136.353.camel@debian>	<20110322161405.GB19716@quack.suse.cz>
	 <x49r59zrqu9.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 14:45:39 +0800
Message-ID: <1300949139.30136.1543.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-23 at 01:46 +0800, Jeff Moyer wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> > Jeff, I suppose the log files of fs_mark processes are on the same
> > device as the test directory, aren't they - that might explain the
> > flusher thread doing IO? The patch below
> 
> No.  My test environments are sane.  The file system is on a completely
> separate disk and it is unmounted and remounted in between each run.
> That should take care of any lost flushes.

Jeff, why not give a try with Jan's fs_mark patch? Maybe the result show
something change. :) 

> 
> Did you receive my last couple of private emails commenting on the trace
> data?
> 
> Cheers,
> Jeff


