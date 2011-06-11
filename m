Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587Ab1FKDJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 23:09:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:45739 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756969Ab1FKDJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 23:09:14 -0400
Date: Fri, 10 Jun 2011 20:09:07 -0700
From: Greg KH <gregkh@suse.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] tty/serial: Add devicetree support for nVidia Tegra
 serial ports
Message-ID: <20110611030907.GA10921@suse.de>
References: <20110611024117.12058.46473.stgit@ponder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110611024117.12058.46473.stgit@ponder>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 08:42:56PM -0600, Grant Likely wrote:
> Enables the tegra serial port to be probed from device tree data.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
> 
> Greg, if it's okay by you, I'll queue this one for v3.1 via the
> devicetree/next tree.

Fine with me:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

