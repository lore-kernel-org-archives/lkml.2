Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab2CAUPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:15:07 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7763 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab2CAUPF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:15:05 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 01 Mar 2012 12:14:39 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Alan Ott <alan@signal11.us>, Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 1 Mar 2012 12:14:37 -0800
Subject: RE: [PATCH 7/8] ARM: tegra: export usb phy symbols
Thread-Topic: [PATCH 7/8] ARM: tegra: export usb phy symbols
Thread-Index: Acz34V9VDMAKH7yeTfKcMHXodcPGxAABn1Ww
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BE861731@HQMAIL01.nvidia.com>
References: <1330630010-11241-1-git-send-email-alan@signal11.us>
 <1330630010-11241-8-git-send-email-alan@signal11.us>
In-Reply-To: <1330630010-11241-8-git-send-email-alan@signal11.us>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Ott wrote at Thursday, March 01, 2012 12:27 PM:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The ehci driver can be a module, so the functions provided
> by the tegra platform code used by ehci-tegra need to
> be exported.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

I think this one need to add:

#include <linux/export.h>

In the relevant place.

-- 
nvpublic

