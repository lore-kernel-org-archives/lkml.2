Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab2ASHZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 02:25:20 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64313 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752548Ab2ASHZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 02:25:18 -0500
Date: Thu, 19 Jan 2012 09:25:03 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Ronen Hod <rhod@redhat.com>
cc: leonid.moiseichuk@nokia.com, riel@redhat.com, minchan@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, rientjes@google.com,
        kosaki.motohiro@gmail.com, hannes@cmpxchg.org, mtosatti@redhat.com,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com
Subject: Re: [RFC 1/3] /dev/low_mem_notify
In-Reply-To: <4F175706.8000808@redhat.com>
Message-ID: <alpine.LFD.2.02.1201190922390.3033@tux.localdomain>
References: <1326788038-29141-1-git-send-email-minchan@kernel.org> <1326788038-29141-2-git-send-email-minchan@kernel.org> <CAOJsxLHGYmVNk7D9NyhRuqQDwquDuA7LtUtp-1huSn5F-GvtAg@mail.gmail.com> <4F15A34F.40808@redhat.com> <alpine.LFD.2.02.1201172044310.15303@tux.localdomain>
 <84FF21A720B0874AA94B46D76DB98269045596AE@008-AM1MPN1-003.mgdnok.nokia.com> <CAOJsxLGiG_Bsp8eMtqCjFToxYAPCE4HC9XCebpZ+-G8E3gg5bw@mail.gmail.com> <84FF21A720B0874AA94B46D76DB98269045596EA@008-AM1MPN1-003.mgdnok.nokia.com> <CAOJsxLG4hMrAdsyOg6QUe71SPqEBq3eZXvRvaKFZQo8HS1vphQ@mail.gmail.com>
 <84FF21A720B0874AA94B46D76DB982690455978C@008-AM1MPN1-003.mgdnok.nokia.com> <4F175706.8000808@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jan 2012, Ronen Hod wrote:
> I believe that it will be best if the kernel publishes an ideal 
> number_of_free_pages (in /proc/meminfo or whatever). Such number is easy to 
> work with since this is what applications do, they free pages. Applications 
> will be able to refer to this number from their garbage collector, or before 
> allocating memory also if they did not get a notification, and it is also 
> useful if several applications free memory at the same time.

Isn't

/proc/sys/vm/min_free_kbytes

pretty much just that?

 			Pekka
