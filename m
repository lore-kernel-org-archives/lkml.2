Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab2ASHel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 02:34:41 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:45077 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752535Ab2ASHek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 02:34:40 -0500
Date: Thu, 19 Jan 2012 09:34:34 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: leonid.moiseichuk@nokia.com
cc: riel@redhat.com, minchan@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        mel@csn.ul.ie, rientjes@google.com, kosaki.motohiro@gmail.com,
        hannes@cmpxchg.org, mtosatti@redhat.com, akpm@linux-foundation.org,
        rhod@redhat.com, kosaki.motohiro@jp.fujitsu.com
Subject: RE: [RFC 1/3] /dev/low_mem_notify
In-Reply-To: <84FF21A720B0874AA94B46D76DB982690455978C@008-AM1MPN1-003.mgdnok.nokia.com>
Message-ID: <alpine.LFD.2.02.1201190933480.3033@tux.localdomain>
References: <1326788038-29141-1-git-send-email-minchan@kernel.org> <1326788038-29141-2-git-send-email-minchan@kernel.org> <CAOJsxLHGYmVNk7D9NyhRuqQDwquDuA7LtUtp-1huSn5F-GvtAg@mail.gmail.com> <4F15A34F.40808@redhat.com> <alpine.LFD.2.02.1201172044310.15303@tux.localdomain>
 <84FF21A720B0874AA94B46D76DB98269045596AE@008-AM1MPN1-003.mgdnok.nokia.com> <CAOJsxLGiG_Bsp8eMtqCjFToxYAPCE4HC9XCebpZ+-G8E3gg5bw@mail.gmail.com> <84FF21A720B0874AA94B46D76DB98269045596EA@008-AM1MPN1-003.mgdnok.nokia.com> <CAOJsxLG4hMrAdsyOg6QUe71SPqEBq3eZXvRvaKFZQo8HS1vphQ@mail.gmail.com>
 <84FF21A720B0874AA94B46D76DB982690455978C@008-AM1MPN1-003.mgdnok.nokia.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jan 2012, leonid.moiseichuk@nokia.com wrote:
> Paul Mundt noticed that and we stopped use percentage in 2006 for n770 update.
> He was right.
> Percents are useless and do not correlate with other kernel APIs like sysinfo().

I changed the code to use number of pages. Thanks!

 			Pekka
