Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422839Ab2LGQhI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 11:37:08 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49469 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422824Ab2LGQhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 11:37:06 -0500
Date: Fri, 7 Dec 2012 08:37:02 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Calvin Walton <calvin.walton@kepstin.ca>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Peter Huewe <peterhuewe@gmx.de>
Subject: Re: [ 24/27] i915: Quirk no_lvds on Gigabyte GA-D525TUD ITX
 motherboard
Message-ID: <20121207163702.GA15361@kroah.com>
References: <20121207005825.232489605@linuxfoundation.org>
 <20121207005833.008375861@linuxfoundation.org>
 <CAF1iTgtAtu6PbGab4Pt3ppMQs0U9nmxzUsQV-ZapCNArofmtnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF1iTgtAtu6PbGab4Pt3ppMQs0U9nmxzUsQV-ZapCNArofmtnw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 11:36:16PM -0500, Calvin Walton wrote:
> Sorry, dropped the CCs when I replied... I don't normally use the
> Gmail web interface :)
> 
> On Thu, Dec 6, 2012 at 7:59 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > 3.6-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Calvin Walton <calvin.walton@kepstin.ca>
> >
> > commit a51d4ed01e5bb39d2cf36a12f9976ab08872c192 upstream.
> >
> > This board is incorrectly detected as having an LVDS connector,
> 
> $ git describe --contains a51d4ed01e5bb39d2cf36a12f9976ab08872c192
> v3.6-rc4~5^2~3^2
> 
> This patch was already included in Linus's 3.6 upstream release, so it
> doesn't need to be (re-)applied to the 3.6.x stable tree. I'm
> surprised it applied at all, it must need some fuzz to add the
> duplicate entry...?

Ah, yes, it did, thanks for catching that, I've now dropped this from
the 3.6-stable tree.

greg k-h
