Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab1CBKfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 05:35:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:12259 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756525Ab1CBKfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 05:35:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,252,1297065600"; 
   d="scan'208";a="715131404"
Date: Wed, 2 Mar 2011 11:34:46 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-mmc@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
        Chris Ball <cjb@laptop.org>, David Woodhouse <dwmw2@infradead.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] tmio: silence warnings introduced by mfd changes
Message-ID: <20110302103446.GE16181@sortiz-mobl>
References: <20110301154230.df32be17.sfr@canb.auug.org.au>
 <20110301105322.48754094@debxo>
 <20110301123220.705d3368@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110301123220.705d3368@debxo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

On Tue, Mar 01, 2011 at 12:32:20PM -0800, Andres Salomon wrote:
> On Tue, 1 Mar 2011 10:53:22 -0800
> Andres Salomon <dilinger@queued.net> wrote:
> 
> > On Tue, 1 Mar 2011 15:42:30 +1100
> > Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > 
> > > Hi Samuel,
> > > 
> > > After merging the mfd tree, today's linux-next build (x86_64
> > > allmodconfig) produced these warnings:
> > > 
> > > drivers/video/tmiofb.c: In function 'tmiofb_hw_init':
> > > drivers/video/tmiofb.c:270: warning: initialization discards
> > > qualifiers from pointer target type drivers/video/tmiofb.c: In
> > > function 'tmiofb_hw_mode': drivers/video/tmiofb.c:314: warning:
> > > initialization discards qualifiers from pointer target type
> > > drivers/video/tmiofb.c:314: warning: unused variable 'cell'
> > > drivers/video/tmiofb.c: In function 'tmiofb_probe':
> > > drivers/video/tmiofb.c:683: warning: initialization discards
> > > qualifiers from pointer target type drivers/video/tmiofb.c: In
> > > function 'tmiofb_remove': drivers/video/tmiofb.c:811: warning:
> > > initialization discards qualifiers from pointer target type
> > > drivers/video/tmiofb.c: In function 'tmiofb_suspend':
> > > drivers/video/tmiofb.c:941: warning: initialization discards
> > > qualifiers from pointer target type drivers/video/tmiofb.c: In
> > > function 'tmiofb_resume': drivers/video/tmiofb.c:973: warning:
> > > initialization discards qualifiers from pointer target type
> > > 
> > > Introduced by commits 2a79bb1d72f5ac22dff96de340d90d512f852ecb
> > > ("mfd: mfd_cell is now implicitly available to tc6393xb drivers")
> > > and b6361637190e6cb7acb84509499942ada69e7136 ("fb: Use mfd_data
> > > instead of driver_data for tmio-fb").
> > > 
> > 
> > Oops, this should fix that.
> > 
> > 
> > 
> 
> 
> Actually, I noticed that I screwed this up for the other tmio drivers
> as well.  Here's a patch that addresses them all (you can
> ignore the previous patch).
Patch applied, thanks for fixing that.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
