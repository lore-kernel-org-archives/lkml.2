Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab0HBRNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 13:13:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35171 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab0HBRNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 13:13:02 -0400
Date: Mon, 2 Aug 2010 10:05:53 -0700
From: Greg KH <gregkh@suse.de>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [000/165] 2.6.32.17-rc1 -stable review
Message-ID: <20100802170553.GA7767@suse.de>
References: <20100730171550.GA1299@kroah.com>
 <20100801021919.1e8c2adb@katamari>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100801021919.1e8c2adb@katamari>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 01, 2010 at 02:19:19AM -0400, Chuck Ebbert wrote:
> On Fri, 30 Jul 2010 10:15:50 -0700
> Greg KH <gregkh@suse.de> wrote:
> 
> > 
> > This is the start of the stable review cycle for the 2.6.32.17 release.
> > There are 165 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let us know.  If anyone is a maintainer of the proper subsystem, and
> > wants to add a Signed-off-by: line to the patch, please respond with it.
> > 
> > Responses should be made by August 1, 2010, 18:00:00 UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.32.17-rc1.gz
> > and the diffstat can be found below.
> > 
> 
> I still don't see this one in 2.6.32-stable:
> 
> commit 1f5a81e41f8b1a782c68d3843e9ec1bfaadf7d72 upstream.
> Subject: ext4: Make sure the MOVE_EXT ioctl can't overwrite append-only files
> 
> This fixes CVE-2010-2066; I'm pretty sure 2.6.32 is vulnerable.

Ick.  I have 40+ ext4 patches already in this release, and here we
didn't get one that really mattered :)

Ted, care to forward on the needed patch(s) to me?

thanks,

greg k-h
