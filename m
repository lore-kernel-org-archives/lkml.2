Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab1I2TBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 15:01:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58304 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200Ab1I2TB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 15:01:29 -0400
Date: Thu, 29 Sep 2011 11:58:19 -0700
From: Greg KH <gregkh@suse.de>
To: David Henningsson <david.henningsson@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: Re: [228/244] ALSA: HDA: No power nids on 92HD93
Message-ID: <20110929185819.GC8183@suse.de>
References: <20110928220149.403768579@clark.kroah.org>
 <4E83FA65.8060600@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E83FA65.8060600@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 06:56:05AM +0200, David Henningsson wrote:
> Hi Greg,
> 
> thanks for applying this patch, but it makes little sense to do so
> without the other patch "ALSA: HDA: Add support for IDT 92HD93"
> (46724c2e023cb7ba5cd50) added a few days earlier (with cc to
> stable).
> 
> Can you tell me why the above patch was not applied, and in case it
> did not apply cleanly, the location of the tree I need to fix it up
> against?

Odd, I somehow missed that one, my mistake.  There was a period there
where I was picking the patches out of the tree by hand until I got the
system automated again with the changes needed due to the kernel.org
disruption.

I've added the above patch to the tree now, thanks for letting me know.

greg k-h
