Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab0GHUQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:16:27 -0400
Received: from kroah.org ([198.145.64.141]:58255 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab0GHUQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:16:25 -0400
Date: Thu, 8 Jul 2010 13:12:24 -0700
From: Greg KH <greg@kroah.com>
To: Denis Kirjanov <dkirjanov@hera.kernel.org>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -staging] slicoss: kill functions prototypes and
 reorder functions
Message-ID: <20100708201224.GA2387@kroah.com>
References: <20100629085216.GA6391@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100629085216.GA6391@hera.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 08:52:16AM +0000, Denis Kirjanov wrote:
> Reorder functions to kill their prototypes.
> 
> Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>

This doesn't apply to the latest linux-next tree, care to respin it, and
the 2 other patches after this as well?

thanks,

greg k-h
