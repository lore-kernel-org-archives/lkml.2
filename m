Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab0C3W7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 18:59:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:39397 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762Ab0C3W7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 18:59:44 -0400
Date: Tue, 30 Mar 2010 14:45:09 -0700
From: Greg KH <gregkh@suse.de>
To: "L. Alberto Gim??nez" <agimenez@sysvalve.es>
Cc: devel@driverdev.osuosl.org, wfp5p@virginia.edu, bzolnier@gmail.com,
       alan@linux.intel.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: Add new driver ipheth
Message-ID: <20100330214509.GA1388@suse.de>
References: <1269984864-28159-1-git-send-email-agimenez@sysvalve.es> <1269984864-28159-2-git-send-email-agimenez@sysvalve.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269984864-28159-2-git-send-email-agimenez@sysvalve.es>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 11:34:24PM +0200, L. Alberto Gim??nez wrote:
> Add new driver to use tethering with an iPhone device to the staging tree.

Why the staging tree?

What is wrong with the driver that it needs to go there and not to the
main kernel tree?

Any driver added to the staging tree needs a TODO file describing what
needs to be fixed with it, and who to send the patches to.

Did you write this driver?  If not, please put a "From:" line that shows
who did write it.

thanks,

greg k-h
