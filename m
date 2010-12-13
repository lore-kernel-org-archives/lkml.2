Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab0LMKk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 05:40:59 -0500
Received: from sd-11162.dedibox.fr ([88.191.70.230]:50238 "EHLO
	sd-11162.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab0LMKk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 05:40:58 -0500
Date: Mon, 13 Dec 2010 11:40:55 +0100
From: Stelian Pop <stelian@popies.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: Michael Hanselmann <public@hansmi.ch>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Remove myself from MAINTAINERS as I no longer have the
 hardware to test.
Message-ID: <20101213104055.GB2188@calypso>
Reply-To: Stelian Pop <stelian@popies.net>
Mail-Followup-To: Stelian Pop <stelian@popies.net>,
	Jean Delvare <khali@linux-fr.org>,
	Michael Hanselmann <public@hansmi.ch>, Tejun Heo <tj@kernel.org>,
	linux-kernel@vger.kernel.org
References: <1292086307-19211-1-git-send-email-tj@kernel.org>
 <1292086307-19211-21-git-send-email-tj@kernel.org>
 <20101211201931.00414518@endymion.delvare>
 <AANLkTinUko5JfbYTOVujXEKqBHfdSXuqAmVcphWZyOrU@mail.gmail.com>
 <20101213101638.GA2188@calypso>
 <20101213111817.1d2087b0@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101213111817.1d2087b0@endymion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is PPC only, and I can no longer test it.

Subject: [PATCH] Remove myself from MAINTAINERS as I no longer have the hardware to test.

Signed-off-by: Stelian Pop <stelian@popies.net>
---
 MAINTAINERS |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

On Mon, Dec 13, 2010 at 11:18:17AM +0100, Jean Delvare wrote:

> > > > The AMS driver is maintained by Stelian Pop and Michael Hanselmann
> > > > according to MAINTAINERS. I am Cc'ing them both.
> > > 
> > > Change looks good to me, but can't test due to lack of hardware.
> > 
> > Same here. Looks like this driver can be orphaned...
> 
> If so, please submit a patch updating MAINTAINERS. Otherwise you'll
> keep getting patches asking for your acknowledgment.

Here it is.

I'll let Michael remove itself from MAINTAINERS and orphan the
driver if he no longer has any related hardware.

Thanks,

Stelian.

diff --git a/MAINTAINERS b/MAINTAINERS
index 1a1c27b..61d8c41 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -429,7 +429,6 @@ S:	Supported
 F:	arch/x86/kernel/microcode_amd.c
 
 AMS (Apple Motion Sensor) DRIVER
-M:	Stelian Pop <stelian@popies.net>
 M:	Michael Hanselmann <linux-kernel@hansmi.ch>
 S:	Supported
 F:	drivers/macintosh/ams/
-- 
1.7.1
