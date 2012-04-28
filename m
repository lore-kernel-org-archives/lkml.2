Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab2D1S2T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 14:28:19 -0400
Received: from lnx141.hrz.tu-darmstadt.de ([130.83.156.236]:42333 "EHLO
	lnx141.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751638Ab2D1S2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 14:28:17 -0400
X-Greylist: delayed 667 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Apr 2012 14:28:16 EDT
From: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20380.13347.472373.965813@elektron.ikp.physik.tu-darmstadt.de>
Date: Sat, 28 Apr 2012 20:17:07 +0200
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] usb: cp210x: Added support for GPIO (CP2103/4/5)
In-Reply-To: <20120428190502.32eaf294@pyramind.ukuu.org.uk>
References: <1335632134-2488-1-git-send-email-preston.fick@silabs.com>
	<20120428190502.32eaf294@pyramind.ukuu.org.uk>
X-Mailer: VM 7.19 under Emacs 21.3.1
X-PMX-TU: seen v1.2 by 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2012.4.28.180332
X-PMX-RELAY: outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Alan" == Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

...
    Alan> The other question is whether having some custom gpio poking
    Alan> interface is actually a good idea. I suspect probably not. The
    Alan> kernel gpio layer can help a bit but doesn't really solve the
    Alan> problem as there is no way to tie a gpio to a port. Given how many
    Alan> devices seem to have gpios these days I wonder if we need a gpio
    Alan> setting interface via termiox.

Is this really kernel stuff or better handled in libusb(x)?

Bye
-- 
Uwe Bonnes                bon@elektron.ikp.physik.tu-darmstadt.de

Institut fuer Kernphysik  Schlossgartenstrasse 9  64289 Darmstadt
--------- Tel. 06151 162516 -------- Fax. 06151 164321 ----------
