Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776Ab1KPAn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 19:43:57 -0500
Received: from mga11.intel.com ([192.55.52.93]:13251 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932728Ab1KPAn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 19:43:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,517,1315206000"; 
   d="scan'208";a="91061023"
Message-ID: <1321404235.13860.83.camel@yhuang-dev>
Subject: Re: Printk mulitple line message support
From: Huang Ying <ying.huang@intel.com>
To: Joe Perches <joe@perches.com>
Cc: William Douglas <william.r.douglas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 16 Nov 2011 08:43:55 +0800
In-Reply-To: <1321328468.18124.2.camel@Joe-Laptop>
References: <1321253936.13860.35.camel@yhuang-dev>
	 <1321281640.2004.6.camel@Joe-Laptop> <1321318201.13860.51.camel@yhuang-dev>
	 <1321319883.8944.7.camel@Joe-Laptop> <1321321957.13860.64.camel@yhuang-dev>
	 <1321324217.8944.25.camel@Joe-Laptop>
	 <1321325960.13860.75.camel@yhuang-dev>
	 <1321328468.18124.2.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-15 at 11:41 +0800, Joe Perches wrote:
> On Tue, 2011-11-15 at 10:59 +0800, Huang Ying wrote:
> > For multiple part in one line.  I think the better solution may be to
> > assemble them in a line buffer before real output to console to avoid
> > interleaving.  Do you think so?
> 
> Hard to say yes for sure.  Immediacy has some value.
> 
> There are some downsides to preassembly in memory
> constrained systems.
> 
> On the other hand, most uses of pr_cont don't create
> very long lines.

Yes.  And I think too long line is bad and should be warned.

Best Regards,
Huang Ying


