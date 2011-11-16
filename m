Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804Ab1KPApl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 19:45:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:46837 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932732Ab1KPApk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 19:45:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="75904467"
Message-ID: <1321404338.13860.85.camel@yhuang-dev>
Subject: Re: Printk mulitple line message support
From: Huang Ying <ying.huang@intel.com>
To: Joe Perches <joe@perches.com>
Cc: William Douglas <william.r.douglas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 16 Nov 2011 08:45:38 +0800
In-Reply-To: <1321324217.8944.25.camel@Joe-Laptop>
References: <1321253936.13860.35.camel@yhuang-dev>
	 <1321281640.2004.6.camel@Joe-Laptop> <1321318201.13860.51.camel@yhuang-dev>
	 <1321319883.8944.7.camel@Joe-Laptop> <1321321957.13860.64.camel@yhuang-dev>
	 <1321324217.8944.25.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-15 at 10:30 +0800, Joe Perches wrote:
> On Tue, 2011-11-15 at 09:52 +0800, Huang Ying wrote:
> > On Tue, 2011-11-15 at 09:18 +0800, Joe Perches wrote:
> > > I believe you are not solving any real problem
> > > with pr_<level>_ml.
> > > Most all interleaved complete line uses have some
> > > pr_fmt prefix that distinguishes between the sources.
> > Except dev_<level> and netdev_<level>, it appears that many general
> > pr_<level> do not have the prefix.
> 
> I'm working on that.
> There are a lot of them and it's a slog.

What's your solution here?  Fix multiline pr_<level> one by one with
various prefix?  How about lines with same prefix comes from different
CPU?

Best Regards,
Huang Ying


