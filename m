Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab1BDXqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 18:46:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57547 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab1BDXqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 18:46:16 -0500
Date: Fri, 4 Feb 2011 15:44:43 -0800
From: Greg KH <gregkh@suse.de>
To: Andres Salomon <dilinger@queued.net>
Cc: Marek Belisko <marek.belisko@open-nandra.com>, cjb@laptop.org,
        jon.nettleton@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: olpc_dcon: checkpatch.pl fixes for
 olpc_dcon.c file.
Message-ID: <20110204234443.GB4147@suse.de>
References: <1296746572-8998-1-git-send-email-marek.belisko@open-nandra.com>
 <20110204152341.7b869851@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110204152341.7b869851@debxo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 04, 2011 at 03:23:41PM -0800, Andres Salomon wrote:
> No opinions on this patch (there are some things I'd do differently,
> but overall it looks fine).  I'd just like to ensure that if it's
> merged, it gets into Linus's tree quickly so that the DCON reworking
> that I'm planning to do doesn't get sidetracked by conflicts.

It is planned to go to Linus for .39 and is now in the linux-next tree
as of tomorrow.

thanks,

greg k-h
