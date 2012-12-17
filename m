Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab2LQWit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 17:38:49 -0500
Received: from unix.wroclaw.pl ([94.23.28.62]:37794 "EHLO unix.wroclaw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989Ab2LQWir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 17:38:47 -0500
Date: Mon, 17 Dec 2012 23:38:44 +0100
From: Mariusz Kozlowski <mk@lab.zgora.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mariusz Kozlowski <mk@lab.zgora.pl>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [ 00/27] 3.7.1-stable review
Message-ID: <20121217223844.GA3428@mako-laptop>
References: <20121214222251.229078963@linuxfoundation.org>
 <20121217220738.GA3542@mako-laptop>
 <20121217221406.GA20720@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121217221406.GA20720@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Report: SpamAssassin 3.2.5 (2008-06-10) on unix.wroclaw.pl
	Spam=No score=-1.4 bayes=0.5 autolearn=disabled
	Spam Tests:
	* -1.4 ALL_TRUSTED Passed through trusted hosts only via SMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 02:14:06PM -0800, Greg Kroah-Hartman wrote:
> On Mon, Dec 17, 2012 at 11:07:38PM +0100, Mariusz Kozlowski wrote:
> > On Fri, Dec 14, 2012 at 03:01:13PM -0800, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 3.7.1 release.
> > > There are 27 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Sun Dec 16 22:16:56 UTC 2012.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.7.1-rc1.gz
> > > and the diffstat can be found below.
> > 
> > Greg, would that be a problem to send these patches for review to
> > linux-3.7.y branch and mark them with v3.7.1-rc1 commit/tag?
> 
> Yes, it is a problem, sorry.
> 
> > Is something goes wrong there is still place to fix/revert as needed.
> > If not do the final commit/tag that says this is v3.7.1 [1].
> > 
> > It would be easier to automate things by just monitoring linux-stable
> > remote for new tags.
> 
> Automate what?

Automate builing stable -rc kernels so that the builds trigger
themselves when needed and all I have to do is install the kernel and
boot it - I do that on real hardware so this part is done manually so
far (for various reasons).

>You can just look for the patch files to show up on
> kernel.org if you wish to automate testing.

That's already done. Ugly but it works.

> Otherwise, sorry, but creating a git tree of these patches, for the -rc
> kernels, doesn't work with the current work flow.  I have to have the
> ability to remove and add patches and change patches in the middle of
> the series of patches before the final kernel release for a variety of
> reasons, all of which have come up over the years of doing these stable
> kernel releases.
> 
> In other words, I don't ever want to rebase.

Ok. Thanks for explanation.


BTW. Nothing breaks for me so far so nothing to report.
-- 
Mariusz Kozlowski
