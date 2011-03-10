Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab1CJV2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:28:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab1CJV2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:28:18 -0500
Date: Thu, 10 Mar 2011 13:27:47 -0800
From: Greg KH <gregkh@suse.de>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] sysfs: add more info to the oops dump
Message-ID: <20110310212746.GA3361@suse.de>
References: <20110310190227.GA28086@suse.de>
 <1299791440-21545-1-git-send-email-ext-phil.2.carmody@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299791440-21545-1-git-send-email-ext-phil.2.carmody@nokia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 11:10:40PM +0200, Phil Carmody wrote:
> If we're going to remember which file we accessed, we might as well
> also remember whether it was a read or a write, and if the latter,
> some indication of what was written.
> 
> Changes in V2: restrict to just one line.

Looks nicer, but you forgot to address the "magic value" trick you used
that I mentioned last time.  Please fix that up.

thanks,

greg k-h
