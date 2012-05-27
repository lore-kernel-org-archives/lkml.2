Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab2E0UBG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 16:01:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58668 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab2E0UBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 16:01:04 -0400
Date: Mon, 28 May 2012 05:00:58 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 00/91] 3.4.1-stable review
Message-ID: <20120527200058.GB30052@kroah.com>
References: <20120527010903.GA18244@kroah.com>
 <20120527170248.GD10168@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120527170248.GD10168@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2012 at 07:02:48PM +0200, Willy Tarreau wrote:
> Hi Greg,
> 
> On Sun, May 27, 2012 at 10:09:03AM +0900, Greg KH wrote:
> > Note, I've tested this release a bit differently than I have in the
> > past.  For this release, I've only tested it on one machine, my laptop,
> > with a pretty minimal configuration to save on build times.  That means,
> > while this release works for me, it might not for you, and it might not
> > even build at all for you.  Please test to verify that I haven't messed
> > anything up.  I'll give everyone at least an extra day than "normal" for
> > this review cycle before I cut a final 3.4.1 release.
> 
> I've tested it here too on my netbook (atom N270). Tested video (i915),
> ethernet (atl1c), Wifi (ath9k), NFS, suspend. Nothing suspicious to report
> and it built without any issues.
> 
> Good job!

Thanks for reporting and letting us know.

greg k-h
