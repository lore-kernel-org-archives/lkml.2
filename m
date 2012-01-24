Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab2AXSe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 13:34:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755691Ab2AXSey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 13:34:54 -0500
Date: Tue, 24 Jan 2012 16:32:47 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Pekka Enberg <penberg@kernel.org>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan@kernel.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, leonid.moiseichuk@nokia.com,
        kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, rientjes@google.com,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ronen Hod <rhod@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC 1/3] /dev/low_mem_notify
Message-ID: <20120124183247.GA19853@amt.cnet>
References: <1326788038-29141-1-git-send-email-minchan@kernel.org>
 <20120124154001.GB10990@amt.cnet>
 <1327420880.13624.24.camel@jaguar>
 <201201241625.55295.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201241625.55295.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 04:25:55PM +0000, Arnd Bergmann wrote:
> On Tuesday 24 January 2012, Pekka Enberg wrote:
> > On Tue, 2012-01-24 at 13:40 -0200, Marcelo Tosatti wrote:
> > > What is the practical advantage of a syscall, again?
> > 
> > Why do you ask? The advantage for this particular case is not needing to
> > add ioctls() for configuration and keeping the file read/write ABI
> > simple.
> 
> The two are obviously equivalent and there is no reason to avoid
> ioctl in general. However I agree that the syscall would be better
> in this case, because that is what we tend to use for core kernel
> functionality, while character devices tend to be used for I/O device
> drivers that need stuff like enumeration and permission management.
> 
> 	Arnd

Makes sense.

