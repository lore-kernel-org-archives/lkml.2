Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab1AJCbX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 21:31:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:8006 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab1AJCbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 21:31:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,297,1291622400"; 
   d="scan'208";a="875911439"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 2/2 v2] xen: HVM X2APIC support
Date: Mon, 10 Jan 2011 10:34:36 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-23-generic; KDE/4.5.1; x86_64; ; )
Cc: Ian Campbell <ijc@hellion.org.uk>, Jeremy Fitzhardinge <jeremy@goop.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
References: <1292912329-12451-1-git-send-email-sheng@linux.intel.com> <201101061805.27674.sheng@linux.intel.com> <20110106150058.GB3404@dumpdata.com>
In-Reply-To: <20110106150058.GB3404@dumpdata.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101101034.36524.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 January 2011 23:00:58 Konrad Rzeszutek Wilk wrote:
> On Thu, Jan 06, 2011 at 06:05:27PM +0800, Sheng Yang wrote:
> > On Thursday 06 January 2011 17:35:57 Ian Campbell wrote:
> > > On Thu, 2011-01-06 at 17:23 +0800, Sheng Yang wrote:
> > > > Thanks for the comments, but seems it's a little late. The patches
> > > > have been there for more than a month since the first version, and
> > > > now they are finally in the tree... And since it's not a bug, could
> > > > we leave it to the later clean up?
> > > 
> > > Sure. Are you going to do that?
> > 
> > OK, I would do it later.
> 
> Please test that
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git works for
> you.

Works well for me, and thanks for updating with Ian's comments!

--
regards
Yang, Sheng
