Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab0C3Uc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 16:32:29 -0400
Received: from kroah.org ([198.145.64.141]:50794 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab0C3Uc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 16:32:26 -0400
Date: Tue, 30 Mar 2010 13:08:42 -0700
From: Greg KH <greg@kroah.com>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: linux-kernel@vger.kernel.org,
       "adel.gadllah@gmail.com" <adel.gadllah@gmail.com>,
       "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>,
       reinette chatre <reinette.chatre@intel.com>,
       "linville@tuxdriver.com" <linville@tuxdriver.com>,
       "stable@kernel.org" <stable@kernel.org>
Subject: Re: [stable] patch iwlwifi-silence-tfds_in_queue-message.patch
	added to 2.6.32-stable tree
Message-ID: <20100330200842.GF1693@kroah.com>
References: <12698953011038@site> <1269900575.2446.3425.camel@rchatre-DESK> <20100329222404.GA10927@suse.de> <4BB1A532.6030502@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB1A532.6030502@canonical.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 09:16:02AM +0200, Stefan Bader wrote:
> Greg KH wrote:
> > On Mon, Mar 29, 2010 at 03:09:35PM -0700, reinette chatre wrote:
> >> Hi,
> >>
> >> On Mon, 2010-03-29 at 13:41 -0700, gregkh@suse.de wrote:
> >>> This is a note to let you know that we have just queued up the patch titled
> >>>
> >>>     Subject: iwlwifi: Silence tfds_in_queue message
> >>>
> >>> to the 2.6.32-stable tree.
> >> [...]
> >>
> >> Please note that this patch is really just masking a problem introduced
> >> by a 2.6.32 backported patch. The real fix is
> >> https://patchwork.kernel.org/patch/86722/ which should be included in
> >> 2.6.32.
> > 
> > What is the git commit id for that patch?  patchwork links don't help me
> > at all.
> 
> There isn't one. The main problem only exists in 2.6.32.y
> because the final hunk missed to remove the nfreed++ from
> ouside the if.
> 
> Introduced by backport of in 2.6.32.y
> 
> commit a120e912eb51e347f36c71b60a1d13af74d30e83
> Author: Stanislaw Gruszka <sgruszka@redhat.com>
> Date:   Fri Feb 19 15:47:33 2010 -0800
> 
>     iwlwifi: sanity check before counting number of tfds can be free

So, what exactly should I be doing here for the .32 stable queue?

what a mess,

greg k-h
