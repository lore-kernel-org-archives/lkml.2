Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab2LSWHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 17:07:52 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:65331 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab2LSWHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 17:07:46 -0500
X-Greylist: delayed 3462 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Dec 2012 17:07:46 EST
MIME-Version: 1.0
Date: Wed, 19 Dec 2012 23:01:30 +0100
Message-ID: <CADpTngWCVWzDY+++q3n5BtcECT4tVeVKvYppj-1UHw0=MLvK3g@mail.gmail.com>
Subject: 3.7.X vs 3.6.11 HP Folio 9470m brightness regression?
From: Fabio Coatti <fabio.coatti@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I'm testing kernels 3.7.X vs 3.6.11 on an HP Folio 9470m machine, i915
driver for a VGA compatible controller: Intel Corporation 3rd Gen Core
processor Graphics Controller (rev 09) 8086:0166

With 3.6.11, the brightness can be correctly set using fn+f9/10: kde
shows the bar and brightness changes.

With 3.7.1 kde shows the percentage bar and
/sys/class/backlight/acpi_video0/brightness is updated, but the screen
brightness does not changes.

I fear some mistakes in my .config migration to 3.7 but I can't find
which one, so if someone can shed some light I will be very happy :)

logs, dumps and whatever information is needed available on demand (to
keep this message short)

Thanks for any answer
ps: I'm not subscribed, please CC: me if you don't mind, thanks.

--
Fabio
