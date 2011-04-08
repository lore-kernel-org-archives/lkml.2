Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab1DHQNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 12:13:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:51607 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656Ab1DHQNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 12:13:21 -0400
Date: Fri, 8 Apr 2011 09:05:58 -0700
From: Greg KH <gregkh@suse.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Removal of staging/rt2860sta (and rt2870sta)
Message-ID: <20110408160558.GA11902@suse.de>
References: <4D9F2185.10108@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9F2185.10108@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 09:53:57AM -0500, Larry Finger wrote:
> Greg,
> 
> When I looked again at the removal of rt2860sta from staging, it was
> quickly obvious that unless rt2870sta was also removed, very little
> of the code could be removed. As I have no experience with
> rt2800usb, the mainline driver for that device, I went to the
> wireless mailing list with the question. There was one objection to
> the removal, but the maintainers were in favor, thus I will be
> submitting a patch to delete both drivers.
> 
> I did the changes on my local git tree, committed them, and used
> 'git format-patch'. I expected that 'git rm' statements would be
> used to delete the files, but I got normal patch format. As a
> result, the resulting patch is over 2.4 GB, and has over 75,000
> lines. Obviously, I'm reluctant to dump a patch of this size on the
> lists. Is there a way to force git to use "rm" statements, or is
> there some way to handle this large patch?

You can point me at the git tree and I can pull from it :)

thanks,

greg k-h
