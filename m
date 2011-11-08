Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab1KHSnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 13:43:09 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:42514 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab1KHSnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 13:43:07 -0500
Subject: Re: [PATCH] [TRIVIAL] Blackfin: remove bfin_simple_timer.h
From: Paul Bolle <pebolle@tiscali.nl>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <trivial@kernel.org>
In-Reply-To: <CAMjpGUcw-oTat82ETiZXiEWtoG72PZGPVTC_6-fQL4J4D0uQpg@mail.gmail.com>
References: <1320767771.14409.389.camel@x61.thuisdomein>
	 <CAMjpGUcw-oTat82ETiZXiEWtoG72PZGPVTC_6-fQL4J4D0uQpg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 19:43:03 +0100
Message-ID: <1320777783.14409.397.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-08 at 13:07 -0500, Mike Frysinger wrote:
> there is a driver that is out of tree that uses it, but we haven't
> gotten cleaned up for merging.  the header should have been kept as
> part of that merge, but i imagine the initial Blackfin support was a
> bit hectic (as are all initial arch ports) so it was accidentally
> included.

So this header can be removed, can't it?


Paul Bolle

