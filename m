Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171Ab0HDC3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 22:29:37 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50470 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab0HDC3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 22:29:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 4 Aug 2010 11:24:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: Bojan Smojver <bojan@rexursive.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
Message-Id: <20100804112444.bc1a575f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C58CF79.4000406@tuxonice.net>
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
	<4C58C771.6040505@tuxonice.net>
	<20100804110248.13a2452b.kamezawa.hiroyu@jp.fujitsu.com>
	<4C58CF79.4000406@tuxonice.net>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Aug 2010 12:24:57 +1000
Nigel Cunningham <nigel@tuxonice.net> wrote:

> Yes, because what's being written is the snapshot that was created in 
> hibernation_snapshot. Any memory you allocate afterwards is irrelevant 
> because it's not part of that snapshot that was made earlier and is now 
> being written to disk. Think of the point where hibernation_snapshot is 
> called as being like taking a photo, and this later part as like 
> printing the photo. Once you've taken the photo, people in the photo can 
> move around without making any difference to the photo you've taken. So 
> here. Our vmallocs and so on after the snapshot don't affect it.
> 

I see. I misunderstood  swsusp_save().
Sorry for tons of noises.

Thanks,
-Kame

