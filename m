Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab1FOBPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 21:15:06 -0400
Received: from adelie.canonical.com ([91.189.90.139]:58819 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab1FOBPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 21:15:03 -0400
Date: Tue, 14 Jun 2011 22:14:44 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Greg KH <greg@kroah.com>
Cc: stable@linux.kernel.org, donald.h.fry@intel.com, reinette.chatre@intel.com,
        wey-yi.w.guy@intel.com, ilw@linux.intel.com, linville@tuxdriver.com,
        sgruszka@redhat.com, ak@linux.intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [stable] Please revert "iwlagn: Support new 5000 microcode."
 from 2.6.32 and 2.6.33
Message-ID: <20110615011443.GA13680@herton-IdeaPad-Y430>
References: <20110613181317.GA3385@herton-IdeaPad-Y430>
 <20110614230344.GA2065@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110614230344.GA2065@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 04:03:44PM -0700, Greg KH wrote:
> On Mon, Jun 13, 2011 at 03:13:18PM -0300, Herton Ronaldo Krzesinski wrote:
> > The patch ("iwlagn: Support new 5000 microcode") shoudn't have been
> > applied on 2.6.32 and 2.6.33 stable trees, it doesn't support new
> > firmware file format, thus if the new firmware is on the disk, loading
> > fails, as reported on:
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/796336
> > 
> > Support for the iwlagn new firmware file format was only added beginning
> > with 2.6.35 (commit "iwlagn: implement loading a new firmware file
> > type"), so iwlagn works with new firmware only with 2.6.35 or later.
> 
> Can I get an ack from the developer of the patch and the people involved
> with it first?  It was asked to be backported for a reason, so I would
> at least like to get the people who asked for the backport to have a
> chance to respond please.
> 
> It's only nice, why would you exclude them?

I didn't intend to exclude anyone and I'm just reporting it, it didn't
came to my mind CC'ing people while sending to stable, and hopefully
everyone related are CC'ed now.

Also note that this revert request is for 2.6.32 and 2.6.33 *only*

And seems the right thing to do for them.

The other stable release where this was applied (2.6.35) looks fine
but these two are too old to support the new firmware (don't work, need
extra patches backported which weren't, like the commit I mentioned --
commit "iwlagn: implement loading a new firmware file type"), as yourself
can check reading the code/bug report, and what I wrote.

> 
> greg k-h
> 

-- 
[]'s
Herton
