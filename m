Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760863Ab0FQXHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 19:07:32 -0400
Received: from kroah.org ([198.145.64.141]:42908 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755714Ab0FQXHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 19:07:31 -0400
Date: Thu, 17 Jun 2010 16:00:25 -0700
From: Greg KH <greg@kroah.com>
To: Gustavo Silva <silvagustavosilva@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "silvagustavo@users.sourceforge.net" 
	<silvagustavo@users.sourceforge.net>
Subject: Re: [PATCH] Staging: comedi: drivers: fix coding style issues in
 pcl812.c
Message-ID: <20100617230025.GA339@kroah.com>
References: <1276399541-12127-1-git-send-email-silvagustavo@users.sourceforge.net>
 <4C1600C5.2000907@mev.co.uk>
 <AANLkTil7zflTT8Af4YSkhiIHlFH-H9lSqzoOTtO_zD85@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTil7zflTT8Af4YSkhiIHlFH-H9lSqzoOTtO_zD85@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 12:43:31AM -0500, Gustavo Silva wrote:
> 2010/6/14 Ian Abbott <abbotti@mev.co.uk>:
> > On 13/06/10 04:25, Gustavo Silva wrote:
> >> + * Driver: pcl812
> >> + * Description: Advantech PCL-812/PG, PCL-813/B,
> >> + *          ADLink ACL-8112DG/HG/PG, ACL-8113, ACL-8216,
> >> + *          ICP DAS A-821PGH/PGL/PGL-NDA, A-822PGH/PGL, A-823PGH/PGL, A-826PG,
> >> + *          ICP DAS ISO-813
> >> + * Author: Michal Dobes <dobes@tesnet.cz>
> >> + * Devices: [Advantech] PCL-812 (pcl812), PCL-812PG (pcl812pg),
> >> + * PCL-813 (pcl813), PCL-813B (pcl813b), [ADLink] ACL-8112DG (acl8112dg),
> >> + * ACL-8112HG (acl8112hg), ACL-8113 (acl-8113), ACL-8216 (acl8216),
> >> + * [ICP] ISO-813 (iso813), A-821PGH (a821pgh), A-821PGL (a821pgl),
> >> + * A-821PGL-NDA (a821pclnda), A-822PGH (a822pgh), A-822PGL (a822pgl),
> >> + * A-823PGH (a823pgh), A-823PGL (a823pgl), A-826PG (a826pg)
> >
> > Please add extra whitespace (a tab or a couple of spaces) to the
> > "Devices:" continuation lines here, e.g.:
> >
> >  * Devices: [Advantech] PCL-812 (pcl812), PCL-812PG (pcl812pg),
> >  *   PCL-813 (pcl813), PCL-813B (pcl813b), [ADLink] ACL-8112DG (acl8112dg),
> >  *   ACL-8112HG (acl8112hg), ACL-8113 (acl-8113), ACL-8216 (acl8216),
> >  *   [ICP] ISO-813 (iso813), A-821PGH (a821pgh), A-821PGL (a821pgl),
> >  *   A-821PGL-NDA (a821pclnda), A-822PGH (a822pgh), A-822PGL (a822pgl),
> >  *   A-823PGH (a823pgh), A-823PGL (a823pgl), A-826PG (a826pg)
> >
> > This extra whitespace is for the benefit of some scripts we have in
> > comedi and comedilib for extracting the documentation.  (Actually, these
> > scripts don't handle the " * " at the beginning of the line yet, but I'm
> > working on that!)
> >
> > Thanks.
> >
> > --
> > -=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
> > -=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
> >
> 
> Hi Ian,
> 
> Thanks for your comments,
> let me known if this OK for you now.
> 
> Best Regards,
> Gus.
> 
> This is a patch to the pcl812.c file that fixes up the following
> issues:
> 
> ERROR: code indent should use tabs where possible		   x 27
> WARNING: line over 80 characters				   x 37
> WARNING: please, no space before tabs				   x 13
> WARNING: braces {} are not necessary for single statement blocks   x  2
> WARNING: printk() should include KERN_ facility level		   x 22
> WARNING: braces {} are not necessary for any arm of this statement x  5
> 
> Signed-off-by: Gustavo Silva <silvagustavo@users.sourceforge.net>

This patch ended up line-wrapped, can you resend it please?

You can add Ian's signed-off-by to it as well.

thanks,

greg k-h
