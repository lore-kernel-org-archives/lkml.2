Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178Ab0HDCrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 22:47:53 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:35784 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756695Ab0HDCrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 22:47:52 -0400
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
From: Bojan Smojver <bojan@rexursive.com>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <4C58D3B0.10602@tuxonice.net>
References: <1280465201.2600.10.camel@shrek.rexursive.com>
	 <1280486667.2608.1.camel@shrek.rexursive.com>
	 <4C534C9D.8000600@tuxonice.net>
	 <1280532174.2583.1.camel@shrek.rexursive.com>
	 <4C5362E7.3000706@tuxonice.net>
	 <1280538184.2583.11.camel@shrek.rexursive.com>
	 <4C537A01.5040808@tuxonice.net>
	 <1280540035.2658.5.camel@shrek.rexursive.com>
	 <1280551286.3097.6.camel@shrek.rexursive.com>
	 <20100802091752.3c9f180d.kamezawa.hiroyu@jp.fujitsu.com>
	 <1280710453.2727.8.camel@shrek.rexursive.com>
	 <20100802101058.d4f1c7b6.kamezawa.hiroyu@jp.fujitsu.com>
	 <1280712068.2671.0.camel@shrek.rexursive.com>
	 <20100802102750.7d414819.kamezawa.hiroyu@jp.fujitsu.com>
	 <1280713381.2673.2.camel@shrek.rexursive.com>
	 <1280800750.3305.4.camel@shrek.rexursive.com>
	 <1280802642.2627.2.camel@shrek.rexursive.com> <4C58D3B0.10602@tuxonice.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 12:47:50 +1000
Message-ID: <1280890070.2741.11.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 12:42 +1000, Nigel Cunningham wrote:
> Is it  standalone? I'm not seeing the relationship between the two
> parts at the moment. 

Once the compression/decompression gets applied, then it can be a
standalone patch, because sync_read is no longer used (we need the data
_now_ in order to decompress it, so async read would not give us much).

I already have it split on my box, so once I finalize, that's how I'll
send.

Points taken for all the other comments. Thank you.

PS. Right now, I'm seeing segfaults on resume with my
overlapping/in-place approach. So, I'll have to find out what is going
on first.

-- 
Bojan

