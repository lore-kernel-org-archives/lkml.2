Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab2AZQU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 11:20:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972Ab2AZQUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 11:20:22 -0500
Date: Thu, 26 Jan 2012 14:17:58 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Ronen Hod <rhod@redhat.com>
Cc: leonid.moiseichuk@nokia.com, penberg@kernel.org, riel@redhat.com,
        minchan@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, rientjes@google.com,
        kosaki.motohiro@gmail.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com
Subject: Re: [RFC 1/3] /dev/low_mem_notify
Message-ID: <20120126161758.GA28367@amt.cnet>
References: <4F17DCED.4020908@redhat.com>
 <CAOJsxLG3x_R5xq85hh5RvPoD+nhgYbHJfbLW=YMxCZockAXJqw@mail.gmail.com>
 <4F17E058.8020008@redhat.com>
 <84FF21A720B0874AA94B46D76DB9826904559D46@008-AM1MPN1-003.mgdnok.nokia.com>
 <20120124153835.GA10990@amt.cnet>
 <4F1ED77F.4090900@redhat.com>
 <20120124181034.GA19186@amt.cnet>
 <4F1FC2C8.10103@redhat.com>
 <20120125101209.GB29167@amt.cnet>
 <4F1FDDE2.9050609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F1FDDE2.9050609@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >it should free for each notification received, that is, its part?
> >
> >Its easier if there is a goal, a hint of how many pages the process
> >should release.
> 
> I have to agree.
> Still, the amount of memory that an app should free per memory-pressure-level can be best calculated inside the application (based on comfortable_free_pages relative to process RSS, as you suggested).

It is easier if the kernel calculates the target (the application is
free to ignore the hint, of course), because it depends on information 
not readily available in userspace.

>  Fairness is also an issue.
> And, if in the meantime the memory pressure ended, would you recommend that the application will continue with its work?

There appears to be interest in an event to notify that higher levels
of memory are available (see Leonid's email).

