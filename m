Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab0HBBVM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:21:12 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:34944 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab0HBBVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:21:10 -0400
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
From: Bojan Smojver <bojan@rexursive.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Nigel Cunningham <nigel@tuxonice.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20100802101058.d4f1c7b6.kamezawa.hiroyu@jp.fujitsu.com>
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
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Aug 2010 11:21:08 +1000
Message-ID: <1280712068.2671.0.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-02 at 10:10 +0900, KAMEZAWA Hiroyuki wrote:
> Why swsusp can avoid memory leak is that it records which
> pages should be freed after resume in the bitmap, which will be saved
> to image header(?) 

Right. So, are you saying that all allocations in save_image() should be
done using __get_free_page() or __get_free_pages() and not with
vmalloc()?

-- 
Bojan

