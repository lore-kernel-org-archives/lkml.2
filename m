Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab2KNUn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 15:43:59 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35112 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab2KNUn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 15:43:56 -0500
Date: Wed, 14 Nov 2012 12:43:51 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-serial@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [PATCH 1/3] OF: Add helper for matching against linux,stdout-path
Message-ID: <20121114204351.GA5743@kroah.com>
References: <1351849734-9836-1-git-send-email-s.hauer@pengutronix.de>
 <1351849734-9836-2-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351849734-9836-2-git-send-email-s.hauer@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 10:48:52AM +0100, Sascha Hauer wrote:
> devicetrees may have a linux,stdout-path property in the chosen
> node describing the console device. This adds a helper function
> to match a device against this property so a driver can call
> add_preferred_console for a matching device.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  drivers/of/Kconfig        |    3 +++
>  drivers/of/Makefile       |    1 +
>  drivers/of/of_stdout.c    |   27 +++++++++++++++++++++++++++
>  include/linux/of_stdout.h |   24 ++++++++++++++++++++++++
>  4 files changed, 55 insertions(+)
>  create mode 100644 drivers/of/of_stdout.c
>  create mode 100644 include/linux/of_stdout.h

I need an ACK from the OF maintainers before I can take this through the
tty tree.

thanks,

greg k-h
