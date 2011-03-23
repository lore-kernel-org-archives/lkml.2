Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab1CWNyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:54:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:35124 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946Ab1CWNyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:54:13 -0400
Date: Wed, 23 Mar 2011 06:50:51 -0700
From: Greg KH <gregkh@suse.de>
To: "Weil, Oren jer" <oren.jer.weil@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "david@woodhou.se" <david@woodhou.se>
Subject: Re: [PATCH 0/7] char/mei: Intel MEI Driver
Message-ID: <20110323135051.GA16769@suse.de>
References: <1300791092-14319-1-git-send-email-oren.jer.weil@intel.com>
 <20110322162305.GA14737@suse.de>
 <F28B59AD52D84B479DCA469824475335065A96BD7F@hasmsx503.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F28B59AD52D84B479DCA469824475335065A96BD7F@hasmsx503.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 02:25:18PM +0200, Weil, Oren jer wrote:
> 
> >Are you wanting this version reviewed for inclusion in .40?  If you don't 
> >feel
> >the code is ready for the main kernel tree, do you want it in staging for the 
> >.40
> >release?
> 
> Yes, we would like  this version to be reviewed for .40.
> I feel that the driver is ready for main kernel tree, but we still working on 
> it to make it better.
> 
> I don't think we want to put it in staging.

Why not?  It needs lots of work, as you have noted, are you going to be
able to get it all cleaned up in the next few weeks properly?

If so, great, I'll wait for your next round of patches to take a look at
them again.

thanks,

greg k-h
