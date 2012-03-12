Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab2CLX2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:28:45 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52704 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab2CLX2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:28:44 -0400
Date: Mon, 12 Mar 2012 23:28:19 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Roland Stigge <stigge@antcom.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, w.sang@pengutronix.de,
        kevin.wells@nxp.com, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de
Subject: Re: [PATCH v6 1/3] USB: OHCI-HCD: Rename ohci-pnx4008 to ohci-nxp
Message-ID: <20120312232819.GD10830@n2100.arm.linux.org.uk>
References: <1331430375-31227-1-git-send-email-stigge@antcom.de> <1331430375-31227-2-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331430375-31227-2-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2012 at 02:46:13AM +0100, Roland Stigge wrote:
> Since this driver is compatible with several NXP devices, the driver is renamed
> accordingly. Please combine with the following patch which also changes the
> respective symbol names.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Please use -C or -M when generating these kinds of patches.  It makes
it possible to see what if anything has changed in the renamed file
(and makes the diff smaller.)

Thanks.
