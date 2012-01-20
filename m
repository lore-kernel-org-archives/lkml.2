Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab2ATX53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 18:57:29 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:29245 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab2ATX51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 18:57:27 -0500
Date: Fri, 20 Jan 2012 18:55:08 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge Jeremy Fitzhardinge <jeremy@goop.org>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] xen-blkfront: use bitmap_set() and bitmap_clear()
Message-ID: <20120120235508.GA17260@phenom.dumpdata.com>
References: <1327072528-8479-1-git-send-email-akinobu.mita@gmail.com>
 <1327072528-8479-4-git-send-email-akinobu.mita@gmail.com>
 <20120120152819.GA3959@phenom.dumpdata.com>
 <CAC5umyi9vuOh9Bx_HoB8ieXcVjZsisKOG6mCEM2ZGL7zXCrVTQ@mail.gmail.com>
 <20120120160938.GC3959@phenom.dumpdata.com>
 <20120120151149.04352aac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120120151149.04352aac.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4F19FF61.004E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 03:11:49PM -0800, Andrew Morton wrote:
> On Fri, 20 Jan 2012 11:09:38 -0500
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
> > > 
> > > > Did you test this patch with a large amount of minors?
> > > 
> > > Sorry I didn't do runtime test.
> > 
> > Please do.
> 
> The poor guy probably doesn't know how to test it and surely it would
> be quite a lot of work for him to do so.
> 
> Overall, it would be much more efficient if the tester of this code is
> someone who is set up to easily apply the patch and test it.  ie: the
> code maintainer(s).

<grins>

This patch aside - Andrew how do you deal with a large amount of patches
and make sure they are tested? Is there a weekly Test Tuesday where you 
kick off your automated tests and dilligently look for any variations?

Or is it more of compile the kernel with X features and run it for a week
doing normal (and abnormal!) things to see if it falls over?

Thanks!
