Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab2CLLma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 07:42:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60447 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab2CLLm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 07:42:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH v7 1/4] USB: OHCI-HCD: Rename ohci-pnx4008 to ohci-nxp
Date: Mon, 12 Mar 2012 08:46:28 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, w.sang@pengutronix.de,
        kevin.wells@nxp.com, linux-arm-kernel@lists.infradead.org
References: <1331463219-23293-1-git-send-email-stigge@antcom.de> <1331463219-23293-2-git-send-email-stigge@antcom.de>
In-Reply-To: <1331463219-23293-2-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203120846.29070.arnd@arndb.de>
X-Provags-ID: V02:K0:0UZtT50dbQpdaKMcO8qBrwZKlGCeboMaIiyEENgW1bv
 N0gdOfCpwWUVgJavepqljX3WFGdHJ31UK69D/hd9cYGB3u2K09
 qmRkDnvGlWet1wZQbUJtvmMzLobT/kSstFyfg7Kp08UMMia2XW
 mXKZ+/PJqF1Q1Z637pVNqj1hfq2WA0rIdzNJBcknSnZN5OTvTz
 9eiA6JwDSOxSahGFMLs5N1amkGQPXHkWwUYb9+CKlq0S72PJDv
 XFDd0o+TKA+sZUDagC+Yz86LeI5ju+jtUZmgUzcYGc/w0NnUE1
 eCKFTdYHN/KKW1nTKk3/GO5aCXC6NnvRaHfA6GSuQkY0/e7+5z
 Z9blsp6xzWJPR170qAv4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 March 2012, Roland Stigge wrote:
> Since this driver is compatible with several NXP devices, the driver is renamed
> accordingly. Please combine with the following patch which also changes the
> respective symbol names.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> 

Hi Roland,

As a general comment, it's helpful to use the "-M" flag to git-format-patch
whenever you rename files, because that makes it obvious whether you have
changed anything in the file or not.

> --- /dev/null
> +++ linux-2.6/drivers/usb/host/ohci-nxp.c
> @@ -0,0 +1,453 @@
> +/*
> + * drivers/usb/host/ohci-pnx4008.c
> + *
> + * driver for Philips PNX4008 USB Host
> + *

I think your second patch does not change this comment and probably should.

Just remove the file name from the comment because that one is generally
not helpful.

	Arnd

