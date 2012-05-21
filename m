Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759126Ab2EUVKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 17:10:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759104Ab2EUVKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 17:10:15 -0400
Date: Mon, 21 May 2012 17:09:59 -0400
From: Dave Jones <davej@redhat.com>
To: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Stephen Wilson <wilsons@start.ca>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 3.4-rc7 numa_policy slab poison.
Message-ID: <20120521210959.GF12123@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Christoph Lameter <cl@linux.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Stephen Wilson <wilsons@start.ca>, Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20120517213120.GA12329@redhat.com>
 <20120518185851.GA5728@redhat.com>
 <20120521154709.GA8697@redhat.com>
 <CA+55aFyqMJ1X08kQwJ7snkYo6MxfVKqFJx7LXBkP_ug4LTCZ=Q@mail.gmail.com>
 <20120521200118.GA12123@redhat.com>
 <alpine.DEB.2.00.1205211510480.10940@router.home>
 <20120521202904.GB12123@redhat.com>
 <alpine.DEB.2.00.1205211535050.10940@router.home>
 <20120521203838.GD12123@redhat.com>
 <alpine.DEB.2.00.1205211544340.10940@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205211544340.10940@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 03:47:16PM -0500, Christoph Lameter wrote:
 > On Mon, 21 May 2012, Dave Jones wrote:
 > 
 > > On Mon, May 21, 2012 at 03:36:39PM -0500, Christoph Lameter wrote:
 > >  > On Mon, 21 May 2012, Dave Jones wrote:
 > >  >
 > >  > > It does create log files in the current dir with the parameters used.
 > >  > > You should be able to grep for the pid that caused the actual oops.
 > >  >
 > >  > Ugghh. It screws up the colors on my screeen. Lightgrey on white. Is there
 > >  > any way to get these horrible escape sequences cleared out? If I use
 > >  > "less" to view the output then there are just the escape sequences
 > >  > visible.
 > >
 > > Define them to nothing in trinity.h
 > 
 > Dependencies are not correctly set. I had to do a "make clean" to get a
 > rebuild done.
 > 
 > Cannot set them to "" since the compiler then fails the compile. Set to "
 > " instead but that looks horrible too.
 > 
 > It still wont trigger with
 > 
 > 	./trinity -c mbind

ok, added a --nocolors option now. Re-pull.
I'll look at the dependancy problem next. Thanks for the feedback.

	Dave
