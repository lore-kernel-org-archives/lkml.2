Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab2BQT1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 14:27:04 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54978 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab2BQT1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 14:27:02 -0500
Date: Fri, 17 Feb 2012 14:26:46 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Divy Le Ray <divy@chelsio.com>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: linux-firmware: update cxgb* firmwares
Message-ID: <20120217192646.GB24908@hmsreliant.think-freely.org>
References: <4F35DB79.6070104@chelsio.com>
 <20120211140701.GA5194@neilslaptop.think-freely.org>
 <4F38A526.70900@chelsio.com>
 <4F3CADB7.1030802@chelsio.com>
 <1329450094.3258.34.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329450094.3258.34.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 03:41:34AM +0000, Ben Hutchings wrote:
> On Wed, 2012-02-15 at 23:18 -0800, Divy Le Ray wrote:
> [...]
> > The following changes since commit 38118a598df73d5a9fd72bf04910e8298db82a46:
> > 
> >    linux-firmware: brcm: add firmware for bcm43236 usb device 
> > (2012-02-11 19:20:10 +0000)
> > 
> > are available in the git repository at:
> >    git://git.chelsio.net/pub/git/linux-firmware for-upstream
> > 
> > Divy Le Ray (3):
> >        linux-firmware: rename t4fw.bin
> >        linux-firmware: add t4fw-1.4.16.0.bin firmware for cxgb4 driver.
> >        linux-firmware: update cxgb3 driver firmware to revision 7.12.0
> > 
> >   WHENCE                  |    4 +++-
> >   cxgb3/t3fw-7.12.0.bin   |  Bin 0 -> 31812 bytes
> >   cxgb4/t4fw-1.3.10.0.bin |  Bin 0 -> 241664 bytes
> >   cxgb4/t4fw-1.4.16.0.bin |  Bin 0 -> 298496 bytes
> >   cxgb4/t4fw.bin          |  Bin 241664 -> 17 bytes
> >   5 files changed, 3 insertions(+), 1 deletions(-)
> >   create mode 100755 cxgb3/t3fw-7.12.0.bin
> >   create mode 100644 cxgb4/t4fw-1.3.10.0.bin
> >   create mode 100644 cxgb4/t4fw-1.4.16.0.bin
> >   mode change 100644 => 120000 cxgb4/t4fw.bin
> 
> Are there any versions of the cxgb4 driver that will specifically
> request cxgb4/t4fw-1.3.10.0.bin?  If not, what's the point of keeping it
> around after changing the cxgb4/t4fw.bin symlink?
> 
> Ben.
> 
I think the right thing to do is update the chelsio driver to do exactly that,
request a specific version of firmware (or range of versions), like most other
drivers do.  That way a single system can boot kernels with varying driver
versions, each of which may require a different firmware api level.
Regards
Neil

> > Cheers,
> > Divy
> > 
> > 
> 
> -- 
> Ben Hutchings
> Beware of programmers who carry screwdrivers. - Leonard Brandwein


