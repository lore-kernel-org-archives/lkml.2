Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab0LURzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 12:55:10 -0500
Received: from wolff.to ([65.117.131.163]:55651 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752033Ab0LURzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 12:55:08 -0500
Date: Tue, 21 Dec 2010 11:55:08 -0600
From: Bruno Wolff III <bruno@wolff.to>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Lasse Collin <lasse.collin@tukaani.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Squashfs: add XZ compression support
Message-ID: <20101221175508.GA7180@wolff.to>
References: <4D0071C3.3070500@lougher.demon.co.uk>
 <20101210185214.GA10263@wolff.to>
 <4D0EF4FA.30703@lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0EF4FA.30703@lougher.demon.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 06:17:30 +0000,
  Phillip Lougher <phillip@lougher.demon.co.uk> wrote:
> 
> As far as I'm concerned this makes a good point to make a new Squashfs tools
> release (very few people trust the CVS versions in my experience and always
> go for the last released version).  I'll probably wait for a couple of weeks
> just in case CVS downloaders find any bugs (in practice I hardly ever get any
> bug reports from the CVS version).  This means a Squashfs tools 4.2
> release mid January.   How does this fit in with the release schedules for
> F15 and F16?

For the kernel stuff, I need to wait until it lands. This looks good for
making 2.6.38 which would make F15. If it doesn't then I'll continue to
wait. (Fedora is fairly strict on using upstream for kernel stuff except
where they have dedicated people as for video drivers.) (I may build
some personal kernels with the patches so I can test live images more
completely, but I can get by with testing squashfs-tools independently
for now.)

For squashfs-tools, a mid January release sounds plenty fine. It could slip
a lot and not cause a problem. I have some time off from work coming up next
week and will get a 4.2 prerelease (fromCVS) into rawhide next week so we can
get some testing there.

Thanks!
