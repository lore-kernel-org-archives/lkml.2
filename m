Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab1IMI1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 04:27:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:19114 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373Ab1IMI06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 04:26:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,373,1312182000"; 
   d="scan'208";a="16493079"
Subject: Re: [PATCH -v2] netconsole: switch init_netconsole() to
 late_initcall if build-in
From: Lin Ming <ming.m.lin@intel.com>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
In-Reply-To: <CAM_iQpVsKXn3ZMygOKc699KQPXbt=-yEWMdKFLqYGVucoJ874w@mail.gmail.com>
References: <1315899939.3402.2.camel@snb>
	 <CAM_iQpVsKXn3ZMygOKc699KQPXbt=-yEWMdKFLqYGVucoJ874w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Sep 2011 16:26:53 +0800
Message-ID: <1315902413.6346.0.camel@snb>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-13 at 15:55 +0800, Américo Wang wrote:
> On Tue, Sep 13, 2011 at 3:45 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> > Commit 88491d8(drivers/net: Kconfig & Makefile cleanup) causes a
> > regression that netconsole does not work if netconsole and network
> > device driver are build into kernel, because netconsole is linked
> > before network device driver.
> >
> > Andrew Morton suggested to fix this with initcall ordering.
> > Fixes it by switching init_netconsole() to late_initcall if build-in.
> >
> 
> Putting one or two lines of comments into the code would
> be nicer, otherwise people have to dig git log to see why. ;-)

Will add.

Thanks.


