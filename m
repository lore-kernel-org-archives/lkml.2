Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab2AXQKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 11:10:44 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:39324 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab2AXQKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 11:10:42 -0500
Subject: Re: [RFC 1/3] /dev/low_mem_notify
From: Pekka Enberg <penberg@kernel.org>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: leonid.moiseichuk@nokia.com, rhod@redhat.com, riel@redhat.com,
        minchan@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, rientjes@google.com,
        kosaki.motohiro@gmail.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20120124153835.GA10990@amt.cnet>
References: <CAOJsxLGiG_Bsp8eMtqCjFToxYAPCE4HC9XCebpZ+-G8E3gg5bw@mail.gmail.com>
	 <84FF21A720B0874AA94B46D76DB98269045596EA@008-AM1MPN1-003.mgdnok.nokia.com>
	 <CAOJsxLG4hMrAdsyOg6QUe71SPqEBq3eZXvRvaKFZQo8HS1vphQ@mail.gmail.com>
	 <84FF21A720B0874AA94B46D76DB982690455978C@008-AM1MPN1-003.mgdnok.nokia.com>
	 <4F175706.8000808@redhat.com>
	 <alpine.LFD.2.02.1201190922390.3033@tux.localdomain>
	 <4F17DCED.4020908@redhat.com>
	 <CAOJsxLG3x_R5xq85hh5RvPoD+nhgYbHJfbLW=YMxCZockAXJqw@mail.gmail.com>
	 <4F17E058.8020008@redhat.com>
	 <84FF21A720B0874AA94B46D76DB9826904559D46@008-AM1MPN1-003.mgdnok.nokia.com>
	 <20120124153835.GA10990@amt.cnet>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 24 Jan 2012 18:10:40 +0200
Message-ID: <1327421440.13624.30.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-24 at 13:38 -0200, Marcelo Tosatti wrote:
> Having userspace specify the "sample period" for low memory notification
> makes no sense. The frequency of notifications is a function of the
> memory pressure.

Sure, it makes sense to autotune sample period. I don't see the problem
with letting userspace decide it for themselves if they want to.

			Pekka

