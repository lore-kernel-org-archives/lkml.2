Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab1BYQgD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 11:36:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52658 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932422Ab1BYQgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 11:36:02 -0500
Date: Fri, 25 Feb 2011 08:35:47 -0800
From: Greg KH <gregkh@suse.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt: add a match table pointer to struct device
Message-ID: <20110225163547.GC8523@suse.de>
References: <20110223025233.25131.47193.stgit@localhost6.localdomain6>
 <AANLkTikauP8+PgFyicdSQzJ19ZvqpV=3ZnRTjSvY78qc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikauP8+PgFyicdSQzJ19ZvqpV=3ZnRTjSvY78qc@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 08:46:52AM -0700, Grant Likely wrote:
> Greg, any thoughts on this change?  I'd like to take it via my tree so
> I can finally dump the last vestiges of of_platform_bus_type.

Sorry, I didn't realize you just wanted my review, and not me to take it
directly.

If you want to take it, that's great, no objection from me, feel free to
add:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
to it.

What about the other patch you sent me, do you want me to take that, or
will you?

thanks,

greg k-h
