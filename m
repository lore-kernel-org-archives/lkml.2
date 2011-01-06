Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab1AFPBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 10:01:35 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:46076 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab1AFPBe (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 6 Jan 2011 10:01:34 -0500
Date: Thu, 6 Jan 2011 10:00:58 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Sheng Yang <sheng@linux.intel.com>
Cc: Ian Campbell <ijc@hellion.org.uk>, Jeremy Fitzhardinge <jeremy@goop.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] xen: HVM X2APIC support
Message-ID: <20110106150058.GB3404@dumpdata.com>
References: <1292912329-12451-1-git-send-email-sheng@linux.intel.com>
 <201101061723.29523.sheng@linux.intel.com>
 <1294306557.3831.3610.camel@zakaz.uk.xensource.com>
 <201101061805.27674.sheng@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101061805.27674.sheng@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 06:05:27PM +0800, Sheng Yang wrote:
> On Thursday 06 January 2011 17:35:57 Ian Campbell wrote:
> > On Thu, 2011-01-06 at 17:23 +0800, Sheng Yang wrote:
> > > Thanks for the comments, but seems it's a little late. The patches have
> > > been there for more than a month since the first version, and now they
> > > are finally in the tree... And since it's not a bug, could we leave it
> > > to the later clean up?
> > 
> > Sure. Are you going to do that?
> 
> OK, I would do it later.

Please test that git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git
works for you. 


