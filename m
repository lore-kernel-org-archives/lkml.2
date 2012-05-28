Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab2E1KDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 06:03:55 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46386 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab2E1KDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 06:03:53 -0400
Date: Mon, 28 May 2012 11:03:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Roland Stigge <stigge@antcom.de>
Cc: alan@linux.intel.com, gregkh@linuxfoundation.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de
Subject: Re: [PATCH] serial/of-serial: Add 16654 chip to compatible string
	list
Message-ID: <20120528100338.GI24149@n2100.arm.linux.org.uk>
References: <1338199134-23885-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338199134-23885-1-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 11:58:54AM +0200, Roland Stigge wrote:
> The (ST)16654 chip was missing in the list of supported chips in of-serial.
> This patch adds the string "st16654" to it, and to the documentation.

Something which occurs to me.  Normally, the digit at the end indicates
how many ports are integrated into the device (0=1port, 2=2port, 4=4port.)
Are you sure there isn't a ST16650 which has the same characteristics?

We really should stick with naming these using the single port versions if
at all possible.
