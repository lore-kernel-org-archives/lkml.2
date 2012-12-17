Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab2LQWT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 17:19:56 -0500
Received: from mail-da0-f54.google.com ([209.85.210.54]:42404 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab2LQWTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 17:19:55 -0500
Date: Mon, 17 Dec 2012 14:14:06 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mariusz Kozlowski <mk@lab.zgora.pl>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 00/27] 3.7.1-stable review
Message-ID: <20121217221406.GA20720@kroah.com>
References: <20121214222251.229078963@linuxfoundation.org>
 <20121217220738.GA3542@mako-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121217220738.GA3542@mako-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 11:07:38PM +0100, Mariusz Kozlowski wrote:
> On Fri, Dec 14, 2012 at 03:01:13PM -0800, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.7.1 release.
> > There are 27 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun Dec 16 22:16:56 UTC 2012.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.7.1-rc1.gz
> > and the diffstat can be found below.
> 
> Greg, would that be a problem to send these patches for review to
> linux-3.7.y branch and mark them with v3.7.1-rc1 commit/tag?

Yes, it is a problem, sorry.

> Is something goes wrong there is still place to fix/revert as needed.
> If not do the final commit/tag that says this is v3.7.1 [1].
> 
> It would be easier to automate things by just monitoring linux-stable
> remote for new tags.

Automate what?  You can just look for the patch files to show up on
kernel.org if you wish to automate testing.

Otherwise, sorry, but creating a git tree of these patches, for the -rc
kernels, doesn't work with the current work flow.  I have to have the
ability to remove and add patches and change patches in the middle of
the series of patches before the final kernel release for a variety of
reasons, all of which have come up over the years of doing these stable
kernel releases.

In other words, I don't ever want to rebase.

greg k-h
