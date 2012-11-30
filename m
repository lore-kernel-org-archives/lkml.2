Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab2K3B6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 20:58:23 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37815 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab2K3B6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 20:58:21 -0500
Date: Thu, 29 Nov 2012 17:58:17 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Johannes Berg <johannes.berg@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: Re: [PATCH 188/270] iwlwifi: fix 6000 series channel switch command
Message-ID: <20121130015817.GI13478@kroah.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
 <1353949160-26803-189-git-send-email-herton.krzesinski@canonical.com>
 <1354032158.4266.60.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354032158.4266.60.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 04:02:38PM +0000, Ben Hutchings wrote:
> On Mon, 2012-11-26 at 14:57 -0200, Herton Ronaldo Krzesinski wrote:
> > 3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > commit 8f7b8db6e0557c8437adf9371e020cd89a7e85dc upstream.
> > 
> > The channel switch command for 6000 series devices
> > is larger than the maximum inline command size of
> > 320 bytes. The command is therefore refused with a
> > warning. Fix this by allocating the command and
> > using the NOCOPY mechanism.
> > 
> > Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > [ herton: file name is different on 3.5, code differs a little bit at
> >   the end, adjusted context ]
> > Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> 
> Also missing from 3.4; the filename is different again
> (drivers/net/wireless/iwlwifi/iwl-6000.c) but this should otherwise be
> applicable with one line of fuzz at the end.

Thanks, I forced it in by hand.

greg k-h
